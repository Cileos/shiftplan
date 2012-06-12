class EmployeesController < InheritedResources::Base
  skip_authorize_resource :only => :list
  skip_authorization_check :only => :list
  load_and_authorize_resource

  respond_to :html, :js

  def create
    create! { organization_employees_url(current_organization) }
  end

  def update
    update! { edit_organization_employee_url(current_employee) }
  end

  def list
    @user = User.find(params[:user_id])
    raise CanCan::AccessDenied.new("Not authorized!", :list, User) unless current_user == @user
    @employees = @user.employees
  end

  private

  # TODO more than one organization per planner
  def begin_of_association_chain
    current_organization
  end
end
