# helps stacking bars in hourly views
# it is alchemy code: written live with the designer, untested and works just by magic.
# TODO test
module StackDecoratorHelper
  # Given an Array of Schedulings, it will arrange them in a way that no 2
  # schedulings overlapping in their runtime are on the same stack,
  def pack_in_stacks(records)
    records.each { |r| r.stack = 0 }
    # order by start_hour asc and length_in_hours desc
    sorted = records.sort_by { |r| '%02d-%02d' % [ r.start_hour, 24 - r.length_in_hours] }
    [].tap do |stacked|
      sorted.each do |current|
        until stacked.none? { |s| s.overlap?(current) }
          current.stack += 1
        end
        stacked << current
      end
      stacked.each do |s|
        s.remaining_stack = [0, sorted.select { |o| o.cover?(s) }.group_by(&:stack).count - s.stack - 1].max
      end
    end
  end

  def stack_metadata_for(scheduling)
    {
      start:     Volksplaner::Formatter.metric_hour_string(scheduling.start_metric_hour),
      length:    Volksplaner::Formatter.metric_hour_string(handle_zero_length scheduling.length_in_hours),
      stack:     scheduling.stack.to_s,
      remaining: scheduling.remaining_stack.to_s,
      total:     scheduling.total_stack.to_s
    }
  end

  private

  # In hours view, 0-length schedulings should be shown without quirks
  def handle_zero_length(hours)
    if hours == 0
      0.25
    else
      hours
    end
  end
end

# later Schedulings are in righter stack than earliers
# shorter Schedulings are in righter stack than long ones (so hovers of longs do not cover the shorts)
# no Schedulings in same stack may overlap
