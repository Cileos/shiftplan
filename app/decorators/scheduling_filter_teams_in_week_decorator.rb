class SchedulingFilterTeamsInWeekDecorator < SchedulingFilterWeekDecorator
  def selector_for(name, resource=nil, extra=nil)
    case name
    when :wwt_diff
      %Q~#calendar tbody tr[data-team-id=#{resource.id}] th .wwt_diff~
    else
      super
    end
  end

  def y_attribute
    :team
  end

  def cell_metadata(day, team)
    { :'team-id' => team.try(:id) || 'missing', :date => day.iso8601 }
  end

  def update_legend
  end

  def teams
    organization.teams
  end

  def cell_selector(scheduling)
   %Q~#calendar tbody td[data-date=#{scheduling.date.iso8601}][data-team-id=#{scheduling.try(:team_id) || 'missing'}]~
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

  def wwt_diff_for(team)
    TeamWwtDiffWidget.new(self, team, records).to_html
  end

  def update_wwt_diff_for(team)
    select(:wwt_diff, team).refresh_html wwt_diff_for(team)
  end

  def update_cell_for(scheduling)
    update_wwt_diff_for(scheduling.team) if scheduling.team.present?
    super
  end

  private

  # When the Planner creates a new Team implicitly (by using it in the
  # Quickie), the calendar gets a new row. Instead of fiddily inserting the new
  # row, we re-render the whole calendar.
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
