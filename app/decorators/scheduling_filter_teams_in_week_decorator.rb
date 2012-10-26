class SchedulingFilterTeamsInWeekDecorator < SchedulingFilterWeekDecorator
  def y_attribute
    :team
  end

  def cell_metadata(day, team)
    { :'team-id' => team.id, :date => day.iso8601 }
  end

  def update_legend
  end

  def teams
    organization.teams
  end

  def cell_selector(scheduling)
   %Q~#calendar tbody td[data-date=#{scheduling.date.iso8601}][data-team-id=#{scheduling.team_id}]~
  end

  def coordinates_for_scheduling(scheduling)
    [ scheduling.date, scheduling.team ]
  end
end
