require_dependency 'time_component'
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
      delegate :iso8601, to: :base_for_time_range_components
      before_validation :compose_time_range_from_components
      alias_method_chain :end_minute, :respecting_end_of_day
      alias_method_chain :end_hour, :respecting_end_of_day
      extend Scopes
    end
  end

  # Gives access to all components of the given times
  # For example, given :start it will use the Record#starts_at to create
  # readers and writers for #start_minute, #start_hour, #start_time etc
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
                 :metric_hour,
                 :minute, :minute=,
                 :time, :time=,
                 :hour_present?,
                 :day,
                 to: :#{name}_component, prefix: :#{name}
      EOEVAL
    end
  end

  time_attrs :start
  time_attrs :end

  def time_range
    (starts_at...ends_at)
  end

  def base_for_time_range_components
    @date || (starts_at.present? && starts_at.in_time_zone.beginning_of_day)
  end

  def date
    @date || (date_part_or_default(:to_date) { date_from_human_week_date_attributes })
  end

  def date=(new_date)
    if new_date
      keeping_time do

        @date = if new_date.respond_to?(:year) # date/time like thingy
            new_date
          else
            Time.zone.parse(new_date)
          end.in_time_zone.beginning_of_day

      end
    end
  end

  protected

  def keeping_time
    *saved = start_hour, end_hour, start_minute, end_minute

    yield

    self.starts_at = self.ends_at = nil
    self.start_hour, self.end_hour, self.start_minute, self.end_minute = *saved
  end

  def compose_time_range_from_components
    TimeRangeComposer.new(self).assign!
    reset_start_components!
    reset_end_components!
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

  # Returns the wanted +attr+ from the (start) date, falling back to supplied block.
  def date_part_or_default(attr, &fallback)
    if starts_at.present?
      starts_at.public_send(attr)
      # starts_at.to_date.public_send(attr)
    else
      fallback.present? ? fallback.call : nil
    end
  end

  module Scopes
    def overlapping(first, last)
      first, last = first.utc, last.utc
      t = arel_table
      starts, ends = t[:starts_at], t[:ends_at]

      starts_between = starts.gteq(first).and( starts.lteq(last) )
      ends_between = ends.gteq(first).and( ends.lteq(last) )
      where(starts_between.or(ends_between))
    end

    def starts_between(first, last)
      first, last = first.utc, last.utc
      t = arel_table
      starts = t[:starts_at]

      sbw = starts.gteq(first).and( starts.lteq(last) )
      where(sbw)
    end
  end
end
