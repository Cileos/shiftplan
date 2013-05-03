class TeamMergesController < BaseController
  respond_to :js

  def create
    create! do
      set_flash(:notice)
      account_organization_teams_path(current_account, current_organization, :teams)
    end
  end
end
