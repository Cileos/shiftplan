class TimeRangeComposer
  attr_reader :record

  delegate :start_hour,
           :start_hour_present?,
           :start_minute,
           :end_hour,
           :end_hour_present?,
           :end_minute,
           to: :record

  def initialize(record, opts={})
    @record = record
  end

  def starts_at
    if base && start_hour_present?
      base + start_hour.hours + start_minute.minutes
    end
  end

  def ends_at
    if base && end_hour_present?
      base + end_hour.hours + end_minute.minutes
    end
  end

private

  def base
    record.base_for_time_range_components
  end

end
