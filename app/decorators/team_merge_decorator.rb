class TeamMergeDecorator < ApplicationDecorator
  decorates :team_merge

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :teams
      'div#teams'
    when :team
      "tr#team_#{resource.id}"
    when :merge_button
      "button#merge-button"
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

  def highlight(team)
    select(:team, team).effect('highlight', {}, 3000)
  end

  def disable_merge_button
    select(:merge_button).prop('disabled', true)
  end

  def respond
    unless errors.empty?
      prepend_errors_for(team)
    else
      clear_modal
      update_teams
      highlight(team)
      disable_merge_button
      update_flash
    end
  end
end
