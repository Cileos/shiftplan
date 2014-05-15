class Unavailability < ActiveRecord::Base
  include Quickie::Assignable
  include TimeRangeComponentsAccessible
  include TimePeriodFormatter
  include AllDaySettable

  attr_protected # let everything through, we use strong params and UnavailabilityCreator

  belongs_to :user
  belongs_to :employee

  delegate :account, to: :employee

  def to_quickie
    period
  end

end
