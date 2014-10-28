class TimeRangeComposer
  attr_reader :record

  delegate :start_hour,
           :start_minute,
           :end_hour,
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
      if end_hour == 24 # ?-24 means until end of day (midnight)
        base.end_of_day
      elsif end_hour == 0 # 0-0:15 is just quarter of an hour, 16-0 are eight hours
        if end_minute > 0
          base.tomorrow + end_minute.minutes
        else
          base.end_of_day
        end
      else
        base + end_hour.hours + end_minute.minutes
      end
    end
  end

private

  def base
    record.base_for_time_range_components
  end

  def start_hour_present?
    start_hour.present?
  end

  def end_hour_present?
    end_hour.present?
  end

end
