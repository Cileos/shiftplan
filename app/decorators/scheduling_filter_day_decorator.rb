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

end
