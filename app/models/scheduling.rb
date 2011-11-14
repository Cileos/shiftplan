class Scheduling < ActiveRecord::Base
  belongs_to :plan
  belongs_to :employee

  attr_accessor :day, :quicky

  private
  before_validation :set_starts_and_ends_at
  def set_starts_and_ends_at
    quicky =~ /^(\d{1,2})-(\d{1,2})$/
    self.starts_at = (plan.first_day + day.to_i.days - 1) + $1.to_i.hours
    self.ends_at = (plan.first_day + day.to_i.days - 1) + $2.to_i.hours
  end
end
