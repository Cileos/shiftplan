class TeamsController < InheritedResources::Base
  load_and_authorize_resource

  def update
    update! { organization_teams_url(current_organization) }
  end

  private

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_organization
  end
end
