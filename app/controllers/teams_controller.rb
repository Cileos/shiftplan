class TeamsController < InheritedResources::Base
  load_and_authorize_resource

  private

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_user.organization
  end
end
