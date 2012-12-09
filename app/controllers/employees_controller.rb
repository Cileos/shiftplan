class EmployeesController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js, :json

  before_filter :set_adoptable_employees, only: [:search, :adopt]

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

  def set_adoptable_employees
    search_attrs = { base: current_organization.adoptable_employees }
    search_attrs.merge!(params[:query]) if params[:query].present?
    @adoptable_employees = EmployeeSearch.new(search_attrs.symbolize_keys).fuzzy_results
  end

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_organization
  end

  def end_of_association_chain
    super.order_by_names.order(:created_at)
  end
end
