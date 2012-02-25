class TeamMerge
  include ActiveAttr::Model
  attribute :team, type: Team
  attribute :other_team_id, type: Integer

  validates_presence_of :team
  validates_presence_of :other_team_id

  def other_team
    @other_team ||= team.organization.teams.find other_team_id
  end

  def save
    Team.transaction do
      other_team.schedulings.update_all team_id: team.id
      other_team.destroy
    end
  end
end
