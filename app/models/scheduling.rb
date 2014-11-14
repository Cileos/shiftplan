class Scheduling < ActiveRecord::Base
  include WithPreviousChangesUndone
  include Repeatable

  belongs_to :plan
  belongs_to :employee
  belongs_to :team
  belongs_to :qualification

  delegate :user, to: :employee
  delegate :organization, to: :plan

  before_destroy    :destroy_notifications

  validates_presence_of :plan
  validates_presence_of :starts_at, :ends_at, :year, :week
  validates :starts_at, :ends_at, within_plan_period: true
  validates_with ShiftPeriodValidator, unless: ->(s) { s.start_hour == 0 && s.start_minute == 0 }
  validates_with PeriodValidator

  scope :in_organizations, ->(ids) { where(organizations: { id: ids }) }

  attr_writer :year

  include Quickie::Assignable
  include TimeRangeWeekBasedAccessible
  include TimeRangeComponentsAccessible
  include TimePeriodFormatter

  include AllDaySettable
  include Overnightable
  include ActualLength

  acts_as_commentable
  has_many :comments, -> { order('comments.lft, comments.id') }, as: :commentable # FIXME gets ALL comments, tree structure is ignored

  def commenters
    comments.map(&:employee)
  end

  def self.upcoming
    where("#{table_name}.starts_at >= :now", now: Time.zone.now.beginning_of_day).order("#{table_name}.starts_at ASC")
  end

  def self.starting_in_the_next(interval)
    raise ArgumentError unless interval =~ /\A\d+ [a-z]+\z/
    now = Time.zone.now
    where("#{table_name}.starts_at >= :now", now: now).
      where("#{table_name}.starts_at < TIMESTAMP :now + INTERVAL '#{interval}'", now: now)
  end

  def self.for_organization(organization)
    joins(:plan).where('plans.organization_id' => organization.id)
  end

  def self.for_team(team)
    where(team_id: team.id)
  end

  def self.from_month(date)
    date = date.in_time_zone
    starts_between(date.beginning_of_month, date.end_of_month)
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

  # Because Date and Times are immutable, we have to situps to just change the week and year.
  # must be used on a valid record.
  def move_to_week_and_year!(week, year)
    wday = cwday
    wday = 7 if wday == 0 # sunday. bloody sunday

    *saved_hours = start_hour, end_hour
    *saved_minutes = start_minute, end_minute

    @date = Date.commercial(year, week, wday).in_time_zone.beginning_of_day
    self.starts_at = self.ends_at = self.week = self.year = nil
    self.start_hour, self.end_hour = *saved_hours
    self.start_minute, self.end_minute = *saved_minutes
    save!
    self
  end

  def hour_range
    (start_hour...end_hour)
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
    self.team = organization.teams.find_or_initialize_by(name: new_name)
  end

  def team_shortcut=(shortcut)
    if team && team.new_record?
      team.shortcut = shortcut
    end
  end

  def represents_unavailability
    super || false # default nil => false
  end

  # TODO save start_hour and end_hour or even cache the whole quickie
  def self.quickies
    id = "#{table_name}.id"
    connection.unprepared_statement do # avoid the $1 parameters
      # in a subselect, find the distinct values for quickies in the current scope
      # (MAX works, too - must be aggregated)
      samples = select("MIN(#{id}) AS id")
        .group(%q~date_part('hour', starts_at),
                  date_part('minute', starts_at),
                  date_part('hour', ends_at),
                  date_part('minute', ends_at),
                  team_id~
              )

      # fetch only needed fields to build quickies
      unscoped
        .preload(:team)
        .select(%q~id, starts_at, ends_at, team_id~)
        .where("#{id} IN (#{samples.to_sql})")
        .map(&:quickie)
    end
  end

  def to_s
    %Q~<Scheduling #{id || 'new'} #{date} #{to_quickie}>~
  end

  def inspect
    to_s
  end

  attr_accessor :conflicts
  def conflicting?
    conflicts.present?
  end

private

  def to_quickie
    [ period, team.try(:to_quickie) ].compact.join(' ')
  end

  def destroy_notifications
    Volksplaner.notification_destroyer[self]
  end
end

SchedulingDecorator
