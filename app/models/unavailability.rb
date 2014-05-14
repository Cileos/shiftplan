class Unavailability < ActiveRecord::Base
  include Quickie::Assignable
  include TimeRangeComponentsAccessible
  include TimePeriodFormatter
  include AllDaySettable

  attr_protected # let everything through, we use strong params and UnavailabilityCreator

  belongs_to :user
  belongs_to :employee

  with_options if: :employee do |employee_level|
    employee_level.before_validation :set_user_from_employee, on: :create
  end

  def to_quickie
    period
  end

private

  def set_user_from_employee
    self.user ||= employee.user
  end
end
