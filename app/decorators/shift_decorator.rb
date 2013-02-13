class ShiftDecorator < RecordDecorator
  include TimePeriodFormatter
  decorates :shift
  decorates_association :demands

  delegate :is_overnight?, :previous_day, to: :model

  def metadata
    {
      edit_url: edit_url,
    }
  end

  def demands_sorted_by_qualification_name
    demands.sort_by { |d| d.try(:qualification).try(:name) || '' }
  end
end
