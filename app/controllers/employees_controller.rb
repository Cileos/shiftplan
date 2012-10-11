class EmployeesController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  def create
    create! { account_organization_employees_url(current_account, current_organization) }
  end

  def update
    update! { edit_account_organization_employee_url(current_account, current_organization, current_employee) }
  end

  private

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_organization
  end

  def end_of_association_chain
    super.order_by_names
  end
end
