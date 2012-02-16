require_dependency 'quickie'

class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee

  before_validation :parse_quickie
  validates :starts_at, :ends_at, :plan, :employee,
    :year, :week, :presence => true

  attr_accessor :quickie
  attr_writer   :cwday

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

  def length_in_hours
    (ends_at - starts_at) / 1.hour
  end

  def self.filter(params={})
    SchedulingFilter.new params.merge(:base => self)
  end

  private

  def parse_quickie
    if quickie.present?
      if parsed = Quickie.parse(quickie)
        parsed.fill(self)
        self.quickie = parsed.to_s # clean the entered quickie
      end
    end
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

end

class ActiveSupport::TimeWithZone
  def cweek
    to_date.cweek
  end
end
