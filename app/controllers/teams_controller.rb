class TeamsController < InheritedResources::Base
  load_and_authorize_resource

  def update
    update! { collection_url }
  end

  private

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_user.organization
  end
end
