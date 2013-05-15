# We want our planners only to have to give the date once and specify the start/end hour
# separately. The user specifies time ranges using inputs for the time components
# start_hour and end_hour. (start_minute and end_minute are optional, atm)
# From these time components this module calculates starts_at and ends_at values that can
# be persisted in the database.
# It also rebuilds the time components from starts_at and ends_at for editing purposes.
#
# Prerequisites:
#   @date is set to the wanted start date
#   @start_hour, @end_hour are set
#   @start_minute, @end_minute (optional atm)
#   #end_hour_respecting_end_of_day
#   #end_minute_respecting_end_of_day
#
# Result:
#   #starts_at, #ends_at are set
#
module TimeRangeComponentsAccessible

  def self.included(model)
    model.class_eval do
      before_validation :compose_time_range_from_components
      alias_method_chain :end_minute, :respecting_end_of_day
      alias_method_chain :end_hour, :respecting_end_of_day
    end
  end


  class TimeComponent < Struct.new(:record, :start_or_end)
    FullTimeExp = /\A (?<hour> \d{1,2}) : (?<minute> \d{1,2}) \z/x
    ShortTimeExp = /\A (?<hour> \d{1,2}) \z/x

    def hour=(hour)
      @hour = hour.present?? hour.to_i : nil
    end

    def attr_name
      :"#{start_or_end}s_at"
    end

    def hour
      @hour || (record.public_send(attr_name).present? && record.public_send(attr_name).hour) || 0
    end

    def hour_present?
      @hour.present?
    end

    def time=(time)
      if m = FullTimeExp.match(time)
        self.hour = m[:hour]
        self.minute = m[:minute]
      elsif m = ShortTimeExp.match(time)
        self.hour = m[:hour]
        self.minute = 0
      end
    end

    def time
      '%02d:%02d' % [hour, minute]
    end

    def minute
      @minute || (record.public_send(attr_name).present? && record.public_send(attr_name).min) || 0
    end

    def minute=(minute)
      @minute = minute.present?? minute.to_i : nil
    end
  end


  # Enables access to all components of the given times
  #
  # For example, given :start it will use the Record#starts_at to give access to #start_minute etc
  def self.time_attrs(*names)
    names.each do |name|
      module_eval <<-EOEVAL, __FILE__, __LINE__
        def #{name}_component
          @#{name}_component ||= TimeComponent.new(self, :#{name})
        end
        def reset_#{name}_components!
          @date = nil
          @#{name}_component = nil
        end
        delegate :hour, :hour=,
                 :minute, :minute=,
                 :time, :time=,
                 :hour_present?,
                 to: :#{name}_component, prefix: :#{name}
      EOEVAL
    end
  end

  time_attrs :start
  time_attrs :end


  def base_for_time_range_components
    @date || (starts_at.present? && starts_at.to_date)
  end

  protected

  # FIXME test this!
  def compose_time_range_from_components
    date = base_for_time_range_components
    if date.present? && start_hour_present?
      self.starts_at = date + start_hour.hours + start_minute.minutes

      reset_start_components!
    end
    if date.present? && end_hour_present?
      if end_hour == 0 || end_hour == 24
        self.ends_at = date.end_of_day
      else
        self.ends_at = date + end_hour.hours + end_minute.minutes
      end

      reset_end_components!
    end
  end

  # DateTime#end_of_day returns 23:59:59, which we show as 24 o'clock
  def end_hour_with_respecting_end_of_day
    if end_minute_without_respecting_end_of_day >= 59 and end_hour_without_respecting_end_of_day == 23
      24
    else
      end_hour_without_respecting_end_of_day
    end
  end

  # DateTime#end_of_day returns 23:59:59, which we show as 24 o'clock
  def end_minute_with_respecting_end_of_day
    if end_minute_without_respecting_end_of_day >= 59 and end_hour_without_respecting_end_of_day == 23
      0
    else
      end_minute_without_respecting_end_of_day
    end
  end

end
