require_dependency 'quickie'

class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee

  validates :starts_at, :ends_at, :plan, :employee, :presence => true

  attr_accessor :day
  attr_accessor :quicky

  def start_hour=(hour)
    self.starts_at = day_in_plan + hour.hours
  end

  def end_hour=(hour)
    self.ends_at = day_in_plan + hour.hours
  end


  private
  before_validation :parse_quicky

  def parse_quicky
    if quicky.present?
      if parsed = Quickie.parse(quicky)
        parsed.fill(self)
        self.quicky = parsed.to_s # clean the entered quicky
      end
    end
  end

  def day_in_plan
    plan.day_at(day)
  end

end
