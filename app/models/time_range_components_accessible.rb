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
    end
  end

  def start_hour=(hour)
    @start_hour = hour.present?? hour.to_i : nil
  end

  def start_hour
    @start_hour || starts_at.present? && starts_at.hour
  end

  def start_minute=(minute)
    @start_minute = minute.present?? minute.to_i : nil
  end

  def start_minute
    @start_minute || starts_at.present? && starts_at.min || 0
  end

  def end_hour=(hour)
    @end_hour = hour.present?? hour.to_i : nil
  end

  def end_hour
    @end_hour || (ends_at.present? && end_hour_respecting_end_of_day)
  end

  def end_minute=(minute)
    @end_minute = minute.present?? minute.to_i : nil
  end

  def end_minute
    @end_minute || (ends_at.present? && end_minute_respecting_end_of_day) || 0
  end

  def base_for_time_range_components
    @date || (starts_at.present? && starts_at.to_date)
  end

  protected

  def compose_time_range_from_components
    date = base_for_time_range_components
    if [date, @start_hour].all?(&:present?)
      self.starts_at = date + @start_hour.hours + start_minute.minutes

      # reset
      @date = @start_hour = @start_minute = nil
    end
    if [date, @end_hour].all?(&:present?)
      if @end_hour == 0 || @end_hour == 24
        self.ends_at = date.end_of_day
      else
        self.ends_at = date + @end_hour.hours + end_minute.minutes
      end

      # reset
      @date = @end_hour = @end_minute = nil
    end
  end

  # DateTime#end_of_day returns 23:59:59, which we show as 24 o'clock
  def end_hour_respecting_end_of_day
    if ends_at.min >= 59 and ends_at.hour == 23
      24
    else
      ends_at.hour
    end
  end

  # DateTime#end_of_day returns 23:59:59, which we show as 24 o'clock
  def end_minute_respecting_end_of_day
    if ends_at.min >= 59 and ends_at.hour == 23
      0
    else
      ends_at.min
    end
  end
end
