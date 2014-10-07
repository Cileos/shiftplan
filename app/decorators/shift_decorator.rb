class ShiftDecorator < RecordDecorator
  include TimePeriodFormatter
  include SchedulableDecoratorHelper
  include OvernightableDecoratorHelper

  decorates :shift
  decorates_association :demands

  delegate :is_overnight?, to: :model

  def demands_sorted_by_qualification_name
    demands.sort_by { |d| d.qualification.try(:name) || '' }
  end

  # overnightable
  def starts_on_focussed_day?
    focus_day == day
  end

  def ends_on_focussed_day?
    focus_day == day + 1
  end
end
