class Owners::RegistrationsController < Devise::RegistrationsController
  after_filter :setup_user, :only => :create

  protected

  def setup_user
    resource.setup
  end

  def after_inactive_sign_up_path_for(resource_or_scope)
    new_user_session_path
  end
end

