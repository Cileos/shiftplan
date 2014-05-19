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
  validates_with NextDayWithinPlanPeriodValidator
  validates_with ShiftPeriodValidator, unless: ->(s) { s.start_hour == 0 && s.start_minute == 0 }

  scope :in_organizations, ->(ids) { where(organizations: { id: ids }) }

  attr_writer :year

  include Quickie::Assignable
  include TimeRangeWeekBasedAccessible
  include TimeRangeComponentsAccessible
  include TimePeriodFormatter

  include AllDaySettable
  include Overnightable

  acts_as_commentable
  has_many :comments, as: :commentable, order: 'comments.lft, comments.id' # FIXME gets ALL comments, tree structure is ignored

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
    between(date.beginning_of_month, date.end_of_month)
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
  # FIXME this is the reason to refactor Overnightable
  def move_to_week_and_year!(week, year)
    raise(ArgumentError, "please move previous day instead") if previous_day.present?
    wday = cwday
    wday = 7 if wday == 0 # sunday. bloody sunday
    # next day was set by dup!?
    *saved_hours = start_hour,
                   next_day ? next_day.end_hour : end_hour
    *saved_minutes = start_minute,
                     next_day ? next_day.end_minute : end_minute

    @date = Date.commercial(year, week, wday)
    next_day.destroy if next_day.present? && next_day.persisted?
    self.next_day_id = self.starts_at = self.ends_at = self.week = self.year = nil
    self.start_hour, self.end_hour = *saved_hours
    self.start_minute, self.end_minute = *saved_minutes
    save!
    self
  end

  delegate :iso8601, to: :date

  # returns 3.25 for 3 hours and 15 minutes
  # OPTIMIZE rounding
  def length_in_hours
    (end_hour - start_hour) + (end_minute-start_minute).to_f / 60
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

  def represents_unavailability
    super || false # default nil => false
  end

  # TODO save start_hour and end_hour or even cache the whole quickie
  def self.quickies
    id = "#{table_name}.id"
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
      .includes(:team)
      .includes(:next_day)
      .select(%q~id, starts_at, ends_at, team_id~)
      .where("#{id} IN (#{samples.to_sql})")
      .map(&:quickie)
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

  # Returns the wanted +attr+ from the (start) date, falling back to supplied block.
  def date_part_or_default(attr, &fallback)
    if starts_at.present?
      starts_at.public_send(attr)
      # starts_at.to_date.public_send(attr)
    else
      fallback.present? ? fallback.call : nil
    end
  end

  def destroy_notifications
    Volksplaner.notification_destroyer[self]
  end
end

SchedulingDecorator
