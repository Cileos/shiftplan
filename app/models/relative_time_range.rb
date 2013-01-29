# We want our planners only to have to give the date once and specify the start/end hour separately.
#
# Prerequisites:
#   @date is set to the wanted start date
module RelativeTimeRange

  def self.included(model)
    model.class_eval do
      attr_accessor :start_hour, :end_hour
      before_validation :calculate_time_range_from_date_and_hours
    end
  end

  protected

  def calculate_time_range_from_date_and_hours
    if [@date, @start_hour, @end_hour].all?(&:present?)
      self.starts_at = @date + @start_hour.hours
      if @end_hour.to_i > @start_hour # normal range
        self.ends_at = @date + @end_hour.hours
      else # nightwatch
        self.ends_at = @date.end_of_day
        @next_day_end_hour = @end_hour
      end
    end
  end

end
