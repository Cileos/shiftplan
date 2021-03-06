class ProfileEmployeesController < InheritedResources::Base
  defaults resource_class: Employee, collection_name: 'employees', instance_name: 'employee'

  load_resource :employee
  skip_authorization_check

  before_filter :authorize_update_profile

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
    super.default_sorting
  end

  def resource
    super
  rescue
    nil
  end

  def authorize_update_profile
    authorize! :update_profile, resource || Employee
  end

  private

  def permitted_params
    params.permit employee: [
      :first_name,
      :last_name,
      :avatar,
      :avatar_cache
    ]
  end

end
