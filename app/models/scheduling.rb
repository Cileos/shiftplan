require_dependency 'quickie'

class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee
  belongs_to :team

  delegate :organization, to: :plan

  before_validation :parse_quickie
  after_validation :set_human_date_attributes

  validates_presence_of :plan, :employee
  validates_presence_of :quickie
  validates_presence_of :starts_at, :ends_at, :year, :week, if: :quickie_parsable?
  validates :starts_at, :ends_at, within_plan_period: true
  validates_with NextDayWithinPlanPeriodValidator

  after_create :create_next_day
  attr_accessor :next_day
  attr_reader :next_day_end_hour

  acts_as_commentable
  has_many :comments, as: :commentable, order: 'comments.lft, comments.id' # FIXME gets ALL comments, tree structure is ignored

  def commenters
    comments.map &:employee
  end

  module Stackable
    def bump_remaining_stack
      self.remaining_stack ||= 0
      self.remaining_stack += 1
      stacked_parents.each(&:bump_remaining_stack)
    end

    def self.included(base)
      base.class_eval do
        attr_accessor :stack
        attr_accessor :remaining_stack
        attr_accessor :stacked_parents
      end
    end

    def total_stack
      stack + remaining_stack + 1 # except myself
    end

    # ignores real date, just checks hours
    def overlap?(other)
      other.stack == stack && overlap_ignoring_stack?(other)
    end

    def overlap_ignoring_stack?(other)
      hour_range.cover?(other.start_hour) || other.hour_range.cover?(start_hour)
    end
  end

  include Stackable

  # FIXME #date must be set before setting start_hour and end_hour (hashes beware)
  def start_hour=(hour)
    self.starts_at = date + hour.hours
  end

  def start_hour
    starts_at.hour
  end

  # must be set after start_hour= to ensure proper behaviour
  def end_hour=(hour)
    if hour.to_i > start_hour # normal range
      self.ends_at = date + hour.hours
    else # nightwatch
      self.ends_at = date.end_of_day
      @next_day_end_hour = hour
    end
  end

  def end_hour
    if ends_at.min >= 55 # end of the day is 24, beginning of next day 0
      ends_at.hour + 1
    else
      ends_at.hour
    end
  end

  def hour_range
    (start_hour...end_hour)
  end

  # date of the day the Scheduling starts
  def date
    @date || starts_at_or(:to_date) { date_from_human_date_attributes }
  end

  # Because Date and Times are immutable, we have to situps to just change the week and year.
  # must be used on a valid record.
  def move_to_week_and_year(week, year)
    *saved = cwday, start_hour, end_hour
    self.starts_at = self.ends_at = @date = nil
    self.week, self.year = week, year
    self.cwday, self.start_hour, self.end_hour = *saved
  end

  def date=(new_date)
    if new_date
      if new_date.respond_to?(:to_date)
        @date = new_date.to_date
      else
        @date = Date.parse(new_date)
      end
    end
  end

  # the year, defaults to current
  def year
    super || starts_at_or(:year) { Date.today.year }
  end

  # calendar week, defaults to current
  # be aware: 1 is not always the week containing Jan 1st
  def week
    super || starts_at_or(:cweek) { Date.today.cweek }
  end

  # calendar week day, monday is 1, Sunday is 7, defaults to current day
  def cwday
    @cwday || starts_at_or(:wday) { Date.today.cwday }
  end
  attr_writer :cwday

  # we have two ways to clean and re-generate the quickie, parsed#to_s or
  # the attributes based self#to_quickie. We use the latter here
  def quickie
    to_quickie
  end
  attr_writer :quickie

  def hour_range_quickie
    if starts_at.present? && ends_at.present?
      "#{start_hour}-#{end_hour}"
    end
  end

  delegate :iso8601, to: :date


  # FIXME nightshift
  def length_in_hours
    if start_hour < end_hour
      end_hour - start_hour
    else
      24-start_hour
    end
  end

  def self.filter(params={})
    SchedulingFilter.new params.reverse_merge(:base => self)
  end

  # FIXME going to fail on month/day view
  def concurrent
    SchedulingFilter.new week: week, employee: employee, year: year, plan: plan
  end

  def with_previous_changes_undone
    dup.tap do |copy|
      copy.attributes = attributes_for_undo
    end
  end

  def attributes_for_undo
    previous_changes.map { |k,(o,n)| { k => o }}.inject(&:merge)
  end

  def team_name
    if team
      team.name
    end
  end

  def team_name=(new_name)
    self.team = organization.teams.find_or_initialize_by_name(new_name)
  end

  def team_shortcut=(shortcut)
    if team && team.new_record?
      team.shortcut = shortcut
    end
  end

  # repairs all the missing attributes
  def self.sync!
    transaction do
      without_timestamps do
        [ where(week: nil), where(year: nil) ].each do |collection|
          collection.each do |scheduling|
            scheduling.save!
          end
        end
      end
    end
  end

  # TODO save start_hour and end_hour or even cache the whole quickie
  def self.quickies
    # select the maximal dates because psql wants aggregations and we are just interested in the hours anyway
    includes(:team)
      .select(%q~max(starts_at) AS starts_at, max(ends_at) AS ends_at, team_id~)
      .group(%q~date_part('hour', starts_at), date_part('hour', ends_at), team_id~)
      .map(&:quickie)
  end

  def comments_count
    comments.count
  end

  private

  def parse_quickie
    if @quickie.present?
      if parsed = Quickie.parse(@quickie)
        @parsed_quickie = parsed
        parsed.fill(self)
      else
        @parsed_quickie = nil
        errors.add :quickie, :invalid
      end
    end
  end

  # A Quickie was given and it is parsable. Depends on #parse_quickie to be run in advance.
  def quickie_parsable?
    @quickie.present? && @parsed_quickie.present?
  end

  def to_quickie
    [ hour_range_quickie, team.try(:to_quickie) ].compact.join(' ')
  end


  # calculates the date manually from #year, #week and #cwday
  def date_from_human_date_attributes
    if @cwday
      ( Date.new(year) + week.weeks ).beginning_of_week + (@cwday.to_i - 1).days
    end
  end

  def starts_at_or(attr, &fallback)
    if starts_at.present?
      # In germany, the week with january 4th is the first calendar week.
      # E.g., in 2012, the January 1st is a sunday, so January 1st is in week 52 (of year 2011)
      # So if the month is January (1) but the calendar week is greater than 5, we know
      # that we have to set the year to the previous one. If we do not set week and year
      # of schedulings to the right values than the scheduling filter will not fetch them
      # when visiting the page for a certain calendar week of the year.
      if attr.to_sym == :year && starts_at.month == 1 && starts_at.cweek > 5
        return starts_at.year - 1
      end
      starts_at.public_send(attr)
    else
      fallback.call
    end
  end

  def set_human_date_attributes
    write_attribute(:week, week)
    write_attribute(:year, year)
  end

  # if an hour range spanning over midnight is given, we split the scheduling. the second part is created here
  def create_next_day
    if @next_day_end_hour.present?
      next_day_end_hour = @next_day_end_hour
      @next_day_end_hour = nil # must be cleared to protect it from dupping
      self.next_day = dup.tap do |next_day|
        next_day.quickie = nil
        next_day.date = date + 1.day
        next_day.start_hour = 0
        next_day.end_hour = next_day_end_hour
        # It is important to recalculate the week of the next day. Imagine a scheduling
        # for 2012-01-01 (sunday) with and hour range over midnight is created.  As in
        # germany the week with january 4th is the first calendar week and the January 1st
        # is a sunday, January 1st is in week 52 (of year 2011).  But the next day, will
        # be in calendar week 1 of year 2012.
        next_day.week = next_day.date.cweek # must be recalculated and not copied
        next_day.year = next_day.date.year  # must be recalculated and not copied
        next_day.save!
      end
    end
  end
end

SchedulingDecorator
