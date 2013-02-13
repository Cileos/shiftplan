class ShiftDecorator < RecordDecorator
  include TimePeriodFormatter
  include OvernightableDecoratorHelper
  decorates :shift
  decorates_association :demands

  delegate :is_overnight?, :previous_day, to: :model

  def demands_sorted_by_qualification_name
    demands.sort_by { |d| d.qualification.try(:name) || '' }
  end
end
