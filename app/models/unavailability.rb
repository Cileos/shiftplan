class Unavailability < ActiveRecord::Base
  include Quickie::Assignable
  include TimeRangeComponentsAccessible
  include TimePeriodFormatter
  include AllDaySettable
  include Stackable

  validates_with PeriodValidator

  belongs_to :user
  belongs_to :employee

  delegate :account, to: :employee

  def to_quickie
    period
  end

end
