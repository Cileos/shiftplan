class TeamMerge
  include Draper::Decoratable
  include ActiveAttr::Model

  attribute :team_id, type: Integer
  attribute :other_team_id, type: Integer
  attribute :new_team_id, type: Integer

  validates :team_id, :other_team_id, :new_team_id, presence: true

  def other_team
    @other_team ||= other_team_id? && team.organization.teams.find_by_id(other_team_id)
  end

  def team
    @team ||= team_id? && Team.find_by_id(team_id)
  end

  def new_team
    @new_team ||= new_team_id? && Team.find_by_id(new_team_id)
  end

  def save
    Team.transaction do
      if team == new_team && other_team
        other_team.schedulings.update_all team_id: new_team.id
        other_team.destroy
      elsif other_team == new_team && team
        team.schedulings.update_all team_id: new_team.id
        team.destroy
      end
    end
  end
end

TeamMergeDecorator
