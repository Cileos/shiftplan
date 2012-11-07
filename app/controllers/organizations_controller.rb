class OrganizationsController < InheritedResources::Base
  belongs_to :account
  load_and_authorize_resource

  def create
    create! { dashboard_path }
  end

  def add_members
    params[:employees].each do |employee_id|
      resource.memberships.create! employee_id: employee_id
    end
    set_flash(:notice)
    redirect_to [current_account, resource, :employees]
  end

  protected

  def interpolation_options
    { organization: resource.name }
  end
end
