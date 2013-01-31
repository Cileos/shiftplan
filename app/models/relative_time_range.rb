# We want our planners only to have to give the date once and specify the start/end hour separately.
#
# Prerequisites:
#   @date is set to the wanted start date
#   @start_hour, @end_hour are set
#
# Result:
#   #starts_at, #ends_at are set
#   @next_day_end_hour is set if the ends_at would stretch to the next day
#
module RelativeTimeRange

  def self.included(model)
    model.class_eval do
      before_validation :calculate_time_range_from_date_and_hours
    end
  end

  def start_hour=(hour)
    @start_hour = hour.present?? hour.to_i : nil
  end

  def start_hour
    @start_hour || date_part_or_default(:hour)
  end

  def end_hour=(hour)
    @end_hour = hour.present?? hour.to_i : nil
  end

  def end_hour
    @end_hour || (ends_at.present? && end_hour_respecting_end_of_day)
  end

  protected

  def calculate_time_range_from_date_and_hours
    date = @date || (starts_at.present? && starts_at.to_date)
    if [date, @start_hour, @end_hour].all?(&:present?)
      self.starts_at = date + @start_hour.hours
      self.ends_at = date + @end_hour.hours

      # reset
      @date = @start_hour = @end_hour = nil
    end
  end

end
