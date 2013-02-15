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

  def respond_for_create(resource)
    super
    respond_to_new_team(resource)
  end

  def respond_for_update(resource)
    super
    respond_to_new_team(resource)
  end

  private

  # When the Planner creates a new Team implicitly (by using it in the
  # Quickie), the calendar gets a new row. Instead of fiddily inserting the new
  # row, we re-render it.
  def respond_to_new_team(resource)
    if team = resource.team
      # only used once (by us)
      records_for_team = unsorted_records.for_team(team)
      if records_for_team.count == 1 ||
        (records_for_team.count == 2 && resource.is_overnight?)
        refresh_calendar
      end
    end
  end
end
