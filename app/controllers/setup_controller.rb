class SetupController < InheritedResources::Base
  load_and_authorize_resource
  before_action :ensure_setup_present

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
end
