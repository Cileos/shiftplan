class EmployeesController < BaseController
  nested_belongs_to :account, :organization
  respond_to :html, :js, :json

  before_filter :set_adoptable_employees, only: [:search, :adopt]
  before_filter :set_organization_id_on_employee, only: [:new, :create, :edit, :update]
  tutorial 'employee', only: [:index, :new]

  def new
    @employee.invitation = build_invitation_for_employee(@employee)
    @employee.account = current_account
    new!
  end

  def create
    create! do |success, failure|
      success.html do
        resource.invitation.send_email if resource.invitation.present?
        redirect_to nested_resources_for(current_organization) + [:employees]
      end
    end
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

  def build_invitation_for_employee(employee)
    Invitation.new(employee: employee,
                   organization: current_organization,
                   inviter: current_user.current_employee)
  end

  def set_adoptable_employees
    search_attrs = { base: current_organization.adoptable_employees }
    search_attrs.merge!(params[:query]) if params[:query].present?
    @adoptable_employees = EmployeeSearch.new(search_attrs.symbolize_keys).fuzzy_results
  end

  def collection
    super.tap do |employees|
      unless @_current_org_set
        employees.each do |employee|
          set_organization_id_on_employee(employee)
        end
        @_current_org_set = true
      end
    end
  end

  # we want to use Employee#current_membership in views
  def set_organization_id_on_employee(employee = resource)
    employee.organization_id ||= current_organization.id
  end

  def permitted_params
    permitted_attributes = [
      :first_name,
      :last_name,
      :weekly_working_time,
      :avatar,
      :avatar_cache,
      :organization_id,
      :account_id,
      :planable,
      :shortcut,
      :force_duplicate,
      :invite,
      invitation_attributes: [:email, :organization_id, :inviter_id],
      qualification_ids: []
    ]
    permitted_attributes << :membership_role if planner_or_owner?
    params.permit(employee: permitted_attributes)
  end

  def planner_or_owner?
    ['planner', 'owner'].include?(role)
  end

  def role
    if current_employee.owner?
      'owner'
    elsif current_membership.role == 'planner'
      'planner'
    end
  end
end
