# helps stacking bars in hourly views
# it is alchemy code: written live with the designer, untested and works just by magic.
# TODO test
module StackDecoratorHelper
  # Given an Array of Schedulings, it will arrange them in a way that no 2
  # schedulings overlapping in their runtime are on the same stack,
  def pack_in_stacks(records)
    records.each { |r| r.stack = 0 }
    # order by start_hour asc and length_in_hours desc
    records.sort_by! { |r| '%02d-%02d' % [ r.start_hour, 24 - r.length_in_hours] }
    [].tap do |stacked|
      records.each do |current|
        until stacked.none? { |s| s.overlap?(current) }
          current.stack += 1
        end
        stacked << current
      end
      stacked.each do |s|
        s.remaining_stack = records.select { |o| o.overlap_ignoring_stack?(s) }.group_by(&:stack).count - s.stack - 1
      end
    end
  end

  def stack_metadata_for(scheduling)
    {
      start: scheduling.start_metric_hour,
      length: scheduling.length_in_hours,
      stack: scheduling.stack,
      remaining: scheduling.remaining_stack,
      total: scheduling.total_stack
    }
  end
end

# later Schedulings are in righter stack than earliers
# shorter Schedulings are in righter stack than long ones (so hovers of longs do not cover the shorts)
# no Schedulings in same stack may overlap
