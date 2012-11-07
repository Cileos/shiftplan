class TeamMergesController < InheritedResources::Base
  respond_to :js

  load_and_authorize_resource

  def create
    create! do
      set_flash(:notice)
      account_organization_teams_path(current_account, current_organization, :teams)
    end
  end
end
