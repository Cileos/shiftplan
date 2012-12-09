class ProfileEmployeesController < InheritedResources::Base
  defaults resource_class: Employee, collection_name: 'employees', instance_name: 'employee'

  load_resource :employee
  skip_authorization_check

  before_filter :authorize_update_self

  def update
    update! { edit_profile_employee_path(@employee) }
  end

  def current_employee
    @employee || super
  end

  protected

  def begin_of_association_chain
    current_user
  end

  def end_of_association_chain
    super.order_by_names
  end

  def resource
    begin super; rescue; nil; end
  end

  def authorize_update_self
    authorize! :update_self, resource || Employee
  end

  private

  def resource_params
    [permitted_employee_params]
  end

  def permitted_employee_params
    params.require(:employee).permit(:first_name, :last_name, :avatar)
  end

end
