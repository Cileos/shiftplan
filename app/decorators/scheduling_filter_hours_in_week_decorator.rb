class SchedulingFilterHoursInWeekDecorator < SchedulingFilterWeekDecorator

  # TODO make configurable
  def working_hours
    (0..23).to_a
  end

  def schedulings_for(day)
    records.select {|r| r.date == day}.sort_by(&:start_hour)
  end

end

