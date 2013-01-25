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
