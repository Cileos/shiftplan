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

  # Makes sure that always the first day of an overnight shift is edited.
  # The second day, if present, gets updated in after callbacks accordingly.
  def edit_url
    plan_template = shift.plan_template
    organization = plan_template.organization
    shift_or_previous_day_shift = shift.previous_day ? shift.previous_day : shift
    h.url_for([:edit, organization.account, organization, plan_template, shift_or_previous_day_shift])
  end

  def demands_sorted_by_qualification_name
    demands.sort_by { |d| d.try(:qualification).try(:name) || '' }
  end
end
