class TeamMergesController < BaseController
  nested_belongs_to :account, :organization
  respond_to :js

  def create
    create! do
      set_flash(:notice)
      account_organization_teams_path(current_account, current_organization, :teams)
    end
  end

  private

  def build_resource
    @team_merge = TeamMerge.new team_merge_params
  end

  def team_merge_params
    params.permit(team_merge: [
      :team_id,
      :other_team_id,
      :new_team_id
    ])[:team_merge]
  end
end
