class SchedulingFilterDayDecorator < SchedulingFilterDecorator
  def formatted_range
    I18n.localize date.to_date, format: :default_with_week_day
  end

  # FIXME this does not feel right
  def monday
    date
  end

  def teams
    plan.organization.teams
  end

  def previous_path
    path_to_day(date.yesterday)
  end

  def next_path
    path_to_day(date.tomorrow)
  end

  def today_path
    path_to_day(Date.today)
  end

  # path to exactly the given day
  def path_to_day(day=monday)
    raise(ArgumentError, "please give a date or datetime, got #{day.inspect}") unless day.acts_like?(:date) or day.acts_like?(:time)
    raise(ArgumentError, "can only link to day in day view") unless mode?('day')
    h.send(:"organization_plan_#{mode}_path", h.current_organization, plan, year: day.year, month: day.month, day: day.day)
  end


end
