class EmployeesController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  before_filter :set_other_employees, only: [:search, :adopt]

  def create
    create! { account_organization_employees_path(current_account, current_organization) }
  end

  def update
    update! { edit_account_organization_employee_path(current_account, current_organization, current_employee) }
  end

  def search
  end

  def adopt
  end

  private

  def set_other_employees
    scope = current_organization.other_employees
    if query_params = params[:query]
      if query_params[:first_name].present?
        scope = scope.where("first_name LIKE ?", "#{query_params[:first_name]}%")
      end
      if query_params[:last_name].present?
        scope = scope.where("last_name LIKE ?", "#{query_params[:last_name]}%")
      end
      if query_params[:email].present?
        scope = scope.joins(:user).where("users.email LIKE ?", "#{query_params[:email]}%")
      end
      if query_params[:organization].present?
        scope = scope.joins(:organizations).where(organizations: { id: query_params[:organization] })
      end
    end
    @other_employees = scope
  end

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_organization
  end

  def end_of_association_chain
    super.order_by_names
  end
end
