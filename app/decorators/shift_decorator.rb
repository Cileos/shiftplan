class ShiftDecorator < RecordDecorator
  decorates :shift
  decorates_association :demands

  delegate :is_overnight?, :init_overnight_end_time, :previous_day, to: :model

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

  def period_with_duration
    period + ' (' + duration + 'h)'
  end

  def duration
    "#{hours}:#{minutes}"
  end

  def period
    "#{formatted_start_time}-#{formatted_end_time}"
  end

  def formatted_start_time
    formatted_time(start_hour, start_minute)
  end

  def formatted_end_time
    formatted_time(end_hour, end_minute)
  end

  def formatted_time(hour, minute)
    "#{normalize(hour)}:#{normalize(minute)}"
  end

  def normalize(number)
    number = 0 if number.nil?
    "%02d" % number
  end

  def hours
    @hours ||= normalize((length_in_minutes / 60).to_i)
  end

  def minutes
    @minutes ||= normalize((length_in_minutes % 60).to_i)
  end

  def length_in_minutes
    @length_in_minutes ||= (end_time - start_time) / 60
  end

  def start_time
    @start_time ||= Time.parse(formatted_start_time)
  end

  def end_time
    @end_time ||= Time.parse(formatted_end_time)
  end
end
