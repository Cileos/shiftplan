class ShiftDecorator < RecordDecorator
  decorates :shift
  decorates_association :demands

  def metadata
    {
      edit_url: edit_url,
    }
  end

  def edit_url
    plan_template = shift.plan_template
    organization = plan_template.organization
    h.url_for([:edit, organization.account, organization, plan_template, shift])
  end

  def hour_range_with_duration
    hour_range_quickie + ' (' + length_in_hours.to_s + 'h)'
  end

  def hour_range_quickie
    "#{start_hour}-#{end_hour}"
  end

  def length_in_hours
    end_hour - start_hour
  end
end
