class EmployeesController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js, :json

  before_filter :set_adoptable_employees, only: [:search, :adopt]

  def create
    create! { account_organization_employees_path(current_account, current_organization) }
  end

  def update
    update! { account_organization_employees_path(current_account, current_organization) }
  end

  def search
  end

  # OPTIMIZE this is loosely coupled with OrganizationsController#add_members
  #          they should at least share a Controller, better a model, too
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

  def resource_params
    [permitted_employee_params]
  end

  # OPTIMIZE please move to model and use the role param of update_attributes,
  #          or another way of protecting attributes from within. see railscast 237
  def permitted_employee_params
    if params[:employee].present?
      allowed_params = [ :first_name, :last_name, :avatar, :avatar_cache,
        :weekly_working_time, :account_id, :organization_id, :force_duplicate, :role ]
      e = Employee.find_by_id(params[:id])
      if params[:employee][:role] == 'owner' || e.present? && !can?(:update_role, e)
        allowed_params = allowed_params.reject { |p| p == :role }
      end
      permitted_params = params.require(:employee).permit(*allowed_params)
    end
    permitted_params || params
  end
end
