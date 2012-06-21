class SchedulingFilterTeamsInWeekDecorator < SchedulingFilterWeekDecorator
  def y_attribute
    :team
  end

  def cell_metadata(day, team)
    { team_id: team.id, date: day.iso8601 }
  end

  def update_legend
  end

end
