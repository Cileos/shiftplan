class SchedulingFilterHoursInWeekDecorator < SchedulingFilterWeekDecorator

  include StackDecoratorHelper

  def respond(resource, action=:update)
    super
    remove_focus(resource) if resource.errors.empty?
  end

  def remove_focus(resource)
    if resource.persisted? # if record was just deleted, we cannot build polymorphic_path for it
      select(:scheduling, resource).removeClass('focus')
    end
  end

  # TODO make configurable
  def working_hours
    (0..23).to_a
  end

  def schedulings_for(day)
    pack_in_stacks records.select {|r| r.date == day}
  end

  def cell_metadata(day)
    { date: day.iso8601 }
  end

  def cell_selector(scheduling)
   %Q~#calendar tbody tr td[data-date=#{scheduling.date.iso8601}]~
  end

  # hours are no real coordinates in a table kind of way
  def coordinates_for_scheduling(scheduling)
    [ scheduling.date ]
  end

  # TODO update content: only modify data-stack, do not replace ALL the divs



end

