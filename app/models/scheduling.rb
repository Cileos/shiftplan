require_dependency 'quickie'

class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee
  belongs_to :team

  delegate :organization, to: :plan

  before_validation :parse_quickie
  after_validation :set_human_date_attributes
  validates :starts_at, :ends_at, :plan, :employee,
    :year, :week, :presence => true

  # FIXME #date must be set before setting start_hour and end_hour (hashes beware)
  def start_hour=(hour)
    self.starts_at = date + hour.hours
  end

  def end_hour=(hour)
    self.ends_at = date + hour.hours
  end

  # date of the day the Scheduling starts
  def date
    @date || starts_at_or(:to_date) { date_from_human_date_attributes }
  end

  def date=(new_date)
    if new_date
      @date = Date.parse(new_date)
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
      "#{starts_at.hour}-#{ends_at.hour}"
    end
  end

  delegate :iso8601, to: :date


  def length_in_hours
    (ends_at - starts_at) / 1.hour
  end

  def self.filter(params={})
    SchedulingFilter.new params.reverse_merge(:base => self)
  end

  def concurrent
    SchedulingFilter.new week: week, employee: employee, year: year, plan: plan
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

  private

  def parse_quickie
    if @quickie.present?
      if parsed = Quickie.parse(@quickie)
        parsed.fill(self)
      else
        errors.add :quickie, :invalid
      end
    end
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
    starts_at.present?? starts_at.public_send(attr) : fallback.call
  end

  def set_human_date_attributes
    write_attribute(:week, week)
    write_attribute(:year, year)
  end

end

class ActiveSupport::TimeWithZone
  def cweek
    to_date.cweek
  end
end

SchedulingDecorator
