class TeamMergeController < InheritedResources::Base
  belongs_to :team, singleton: true

  load_and_authorize_resource

  def create
    create! { organization_teams_url(current_organization) }
  end
end
