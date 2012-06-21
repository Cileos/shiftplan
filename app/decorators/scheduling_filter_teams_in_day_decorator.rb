class SchedulingFilterTeamsInDayDecorator < SchedulingFilterDecorator
  def formatted_range
    I18n.localize date.to_date, format: :default_with_week_day
  end

  # this does not feel right
  def monday
    date
  end

  def schedulings_for(team)
    records.select { |r| r.team_id == team.id }.sort_by(&:employee_id)
  end

  def metadata_for(scheduling)
    {
      start: scheduling.start_hour,
      length: scheduling.length_in_hours
    }
  end
end
