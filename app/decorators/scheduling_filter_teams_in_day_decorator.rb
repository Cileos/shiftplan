class SchedulingFilterTeamsInDayDecorator < SchedulingFilterDayDecorator
  include StackDecoratorHelper

  def schedulings_for(team)
    pack_in_stacks records.select { |r| r.team_id == team.id }.sort_by(&:employee_id)
  end

  def cell_metadata(team)
    { :'team-id' => team.id, :date => date.iso8601 }
  end

  def cell_selector(scheduling)
   %Q~#calendar tbody td[data-team-id=#{scheduling.team_id}]~
  end
  alias_method :next_cell_selector, :cell_selector

  def coordinates_for(scheduling)
    [ scheduling.team ]
  end
  alias_method :next_coordinates_for, :coordinates_for

  def nex

  # we only need a sequence of divs
  def list_tag
    nil
  end
end
