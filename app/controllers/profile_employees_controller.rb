class ProfileEmployeesController < InheritedResources::Base
  defaults resource_class: Employee, collection_name: 'employees', instance_name: 'employee'
  load_and_authorize_resource :employee

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
end
