class EmployeesController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  def create
    create! { organization_employees_url(current_organization) }
  end

  def update
    update! { organization_employees_url(current_organization) }
  end

  private

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_organization
  end
end
