require_dependency 'quickie'

class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee

  validates :starts_at, :ends_at, :plan, :employee, :presence => true

  attr_accessor :day
  attr_accessor :quickie

  def start_hour=(hour)
    self.starts_at = day_in_plan + hour.hours
  end

  def end_hour=(hour)
    self.ends_at = day_in_plan + hour.hours
  end

  def week_day
    starts_at.to_date.cwday
  end

  def length_in_hours
    (ends_at - starts_at) / 1.hour
  end


  private
  before_validation :parse_quickie

  def parse_quickie
    if quickie.present?
      if parsed = Quickie.parse(quickie)
        parsed.fill(self)
        self.quickie = parsed.to_s # clean the entered quickie
      end
    end
  end

  def day_in_plan
    plan.day_at(day)
  end

end
