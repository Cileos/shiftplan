class TeamMerge
  include ActiveAttr::Model
  attribute :team_id, type: Integer
  attribute :other_team_id, type: Integer

  # TODO validate the both teams differ
  validates_presence_of :team_id
  validates_presence_of :other_team_id

  def other_team
    @other_team ||= other_team_id? && team.organization.teams.find(other_team_id)
  end

  def team
    @team ||= team_id? && Team.find(team_id)
  end

  def save
    Team.transaction do
      other_team.schedulings.update_all team_id: team.id
      other_team.destroy
    end
  end
end
