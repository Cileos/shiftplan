# helps stacking bars in hourly views
module StackDecoratorHelper
  # Given an Array of Schedulings, it will arrange them in a way that no 2
  # schedulings overlapping in their runtime are on the same layer,
  def pack_in_stacks(records)
    records.each { |r| r.stack = 0 }
    records.sort_by!(&:length_in_hours)
    [].tap do |stacked|
      records.reverse.each do |current|
        until stacked.select { |s| s.overlap?(current) }.empty?
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
      start: scheduling.start_hour,
      length: scheduling.length_in_hours,
      stack: scheduling.stack,
      remaining: scheduling.remaining_stack,
      total: scheduling.total_stack
    }
  end
end
