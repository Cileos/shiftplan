class SchedulingFilterEmployeesInWeekDecorator < SchedulingFilterWeekDecorator

  def schedulings_for(day, employee)
    filter.indexed(day, employee).sort_by(&:start_hour)
  end

  def cell_metadata(day, employee)
    { employee_id: employee.id, date: day.iso8601 }
  end

  # FIXME WTF should use cdata_section to wrap team_styles, but it break the styles
  # TODO put this into the template
  def legend
    h.content_tag(:style) { team_styles } +
      h.render('teams/legend', teams: teams)
  end

  def update_legend
    select(:legend).html legend
  end

  # TODO move into own view to fetch as an organization-specific asset
  # FIXME this is deprecated, isn't it?
  def team_styles
    teams.map do |team|
      %Q~.#{dom_id(team)} { border-color: #{team.color};}~
    end.join(' ')
  end

  def selector_for(*a)
    case name
    when :legend
      '#legend'
    else
      super
    end
  end
end
