class TimeRangeComposer
  attr_reader :record

  def self.from_record_defaulting_to_zero(method)
    file, line = caller.first.split(':', 2)
    line = line.to_i
    module_eval <<-EORUBY, file, line
      def #{method}
        record.#{method}.presence || 0
      end
    EORUBY
  end

  from_record_defaulting_to_zero :start_hour
  from_record_defaulting_to_zero :start_minute
  from_record_defaulting_to_zero :end_hour
  from_record_defaulting_to_zero :end_minute


  def initialize(record, opts={})
    @record = record
  end

  def assign!
    record.starts_at = starts_at
    record.ends_at = ends_at
  end

  def starts_at
    if base && start_hour_present?
      base + start_hour.hours + start_minute.minutes
    end
  end

  def ends_at
    if base && end_hour_present?
      if end_hour == 24 # ?-24 means until end of day (midnight)
        if end_minute > 0
          base.tomorrow + end_minute.minutes
        else
          base.end_of_day
        end
      elsif end_hour == 0 # 0-0:15 is just quarter of an hour, 16-0 are eight hours
        if start_hour == 0 && start_minute < end_minute
          base + end_minute.minutes
        else
          base.tomorrow + end_minute.minutes
        end
      elsif end_hour < start_hour
        base.tomorrow + end_hour.hours + end_minute.minutes
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
