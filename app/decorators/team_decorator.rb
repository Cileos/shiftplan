class TeamDecorator < ApplicationDecorator
  decorates :team

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :teams
      'div#teams'
    else
      super
    end
  end

  def update_teams
    select(:teams).html teams_table
  end

  def teams_table
    h.render('teams/table', teams: h.current_organization.teams.order(:name))
  end

  def respond
    unless errors.empty?
      prepend_errors_for(team)
    else
      clear_modal
      update_teams
      update_flash
    end
  end
end
