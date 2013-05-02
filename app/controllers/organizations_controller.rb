class OrganizationsController < BaseController
  belongs_to :account

  respond_to :html, :js

  def create
    create! { account_path(current_account) }
  end

  def update
    update! { account_path(current_account) }
  end

  # OPTIMIZE MembershipsController#create_multiple, using a tableless model like MultipleMembership
  def add_members
    if params[:employees].present?
      params[:employees].each do |employee_id|
        resource.memberships.create! employee_id: employee_id
      end
      set_flash(:notice)
      redirect_to [current_account, resource, :employees]
    else
      set_flash(:alert)
      redirect_to [:adopt, current_account, resource, :employees]
    end
  end

  protected

  def interpolation_options
    { organization: resource.name }
  end
end
