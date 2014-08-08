class SetupController < InheritedResources::Base
  defaults resource_class: Setup, instance_name: 'setup'
  load_and_authorize_resource
  before_action :ensure_setup_present
  respond_to :json, :html

  protected

  def resource
    @setup ||= current_user.setup
  end

  # the Setup is created during the Signup. If there is none present, either 
  # * the User signed up too early
  # * the User already completed a setup
  # so she already has all neccessary records set up
  def ensure_setup_present
    unless resource
      redirect_to dashboard_path
    end
  end

  def permitted_params
    params.permit(setup: [
      :employee_first_name,
      :employee_last_name,
      :account_name,
      :organization_name,
      :team_names,
    ])
  end
end
