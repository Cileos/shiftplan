require_dependency 'quickie'
require_dependency 'with_previous_changes_undone'

class Scheduling < ActiveRecord::Base
  include WithPreviousChangesUndone

  belongs_to :plan
  belongs_to :employee
  belongs_to :team
  belongs_to :qualification

  delegate :organization, to: :plan

  before_validation :parse_quickie_and_fill_in
  after_save :create_repetitions, if: :repeat_days?

  validates_presence_of :plan
  validates_presence_of :quickie
  validates_presence_of :starts_at, :ends_at, :year, :week, if: :quickie_parsable?
  validates :starts_at, :ends_at, within_plan_period: true
  validates_with NextDayWithinPlanPeriodValidator

  attr_writer :year, :repetitions
  attr_accessor :repeat_days

  include TimeRangeWeekBasedAccessible
  include TimeRangeComponentsAccessible

  include Overnightable

  acts_as_commentable
  has_many :comments, as: :commentable, order: 'comments.lft, comments.id' # FIXME gets ALL comments, tree structure is ignored

  def commenters
    comments.map &:employee
  end

  def self.upcoming
    t = table_name
    where("#{t}.starts_at > :now AND #{t}.starts_at < TIMESTAMP :now + INTERVAL '14 days'", now: Time.zone.now).order("#{t}.starts_at ASC")
  end

  def self.for_organization(organization)
    joins(:plan).where('plans.organization_id' => organization.id)
  end

  def self.for_team(team)
    where(team_id: team.id)
  end

  # Used for dupping, for example in nightshift. #dup won't copy associations,
  # so please add them here if needed.
  def initialize_dup(original)
    super
    self.team = original.team
    self.plan = original.plan
    self.employee = original.employee
  end

  def qualification_name
    try(:qualification).try(:name) || ''
  end

  include Stackable

  def hour_range
    (start_hour...end_hour)
  end

  # date of the day the Scheduling starts
  def date
    @date || date_part_or_default(:to_date) { date_from_human_date_attributes }
  end

  # Because Date and Times are immutable, we have to situps to just change the week and year.
  # must be used on a valid record.
  def move_to_week_and_year(week, year)
    end_hour_or_end_hour_of_next_day = next_day ? next_day.end_hour : end_hour
    *saved = start_hour, end_hour_or_end_hour_of_next_day
    @date = Date.commercial(year, week, cwday)
    self.next_day_id = self.starts_at = self.ends_at = self.week = self.year = nil
    self.start_hour, self.end_hour = *saved
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

  def length_in_hours
    end_hour - start_hour
  end

  def self.filter(params={})
    SchedulingFilter.new params.reverse_merge(:base => self)
  end

  # FIXME going to fail on month/day view
  def concurrent
    SchedulingFilter.new week: week, employee: employee, cwyear: cwyear, plan: plan
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

  def to_s
    %Q~<Scheduling #{date} #{to_quickie}>~
  end

  def normalized_repeat_days
    repeat_days.reject { |d| d.blank? || date.to_s == d }
  end

  def repeat_days?
    repeat_days.present?
  end

  def non_repeatable_attributes
    ['starts_at', 'ends_at', 'created_at', 'updated_at', 'next_day_id']
  end

  def repetitions
    @repetitions || []
  end

  def create_repetitions
    schedulings = []
    normalized_repeat_days.each do |repeat_day|
      s = Scheduling.new(attributes.except(*non_repeatable_attributes))
      s.date = repeat_day
      s.quickie = quickie
      s.save!
      schedulings << s
    end
    self.repetitions = schedulings
  end

  private

  def parse_quickie_and_fill_in
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

  # A Quickie was given and it is parsable. Depends on #parse_quickie_and_fill_in to be run in advance.
  def quickie_parsable?
    @quickie.present? && @parsed_quickie.present?
  end

  def to_quickie
    [ hour_range_quickie, team.try(:to_quickie) ].compact.join(' ')
  end


  # Returns the wanted +attr+ from the (start) date, falling back to supplied block.
  def date_part_or_default(attr, &fallback)
    if starts_at.present?
      starts_at.public_send(attr)
      # starts_at.to_date.public_send(attr)
    else
      fallback.present? ? fallback.call : nil
    end
  end

end

SchedulingDecorator
