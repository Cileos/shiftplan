class SchedulingFilterTeamsInDayDecorator < SchedulingFilterDecorator
  include StackDecoratorHelper

  def formatted_range
    I18n.localize date.to_date, format: :default_with_week_day
  end

  # this does not feel right
  def monday
    date
  end

  def schedulings_for(team)
    pack_in_stacks records.select { |r| r.team_id == team.id }.sort_by(&:employee_id)
  end

  def cell_metadata(team)
    { team_id: team.id, date: date.iso8601 }
  end

  def cell_selector(scheduling)
   %Q~#calendar tbody td[data-team_id=#{scheduling.team_id}]~
  end

  def coordinates_for_scheduling(scheduling)
    [ scheduling.team ]
  end

  def teams
    plan.organization.teams
  end
end
