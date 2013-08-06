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
    @team_merge = TeamMerge.new params[:team_merge]
  end
end
