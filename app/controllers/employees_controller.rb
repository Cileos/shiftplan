class EmployeesController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  before_filter :set_employees_from_other_organizations, only: :new

  def create
    create! { account_organization_employees_path(current_account, current_organization) }
  end

  def update
    update! { edit_account_organization_employee_path(current_account, current_organization, current_employee) }
  end

  def search
    scope = current_account.employees.order_by_names
    if params[:query][:first_name].present?
      scope = scope.where("first_name like ?", "#{params[:query][:first_name]}%")
    end
    if params[:query][:last_name].present?
      scope = scope.where("last_name like ?", "#{params[:query][:last_name]}%")
    end
    @employees_from_other_organizations = scope.all.reject do |e|
      current_organization.employees.include? e
    end
  end

  private

  def set_employees_from_other_organizations
    @employees_from_other_organizations = current_account.employees.order_by_names.reject do |e|
      current_organization.employees.include? e
    end
  end

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_organization
  end

  def end_of_association_chain
    super.order_by_names
  end
end
