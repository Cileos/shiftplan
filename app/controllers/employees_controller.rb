class EmployeesController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  def create
    create! { collection_url }
  end

  def update
    update! { collection_url }
  end

  private

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_user.organization
  end
end
