class SessionsController < Devise::SessionsController

  protected

  def after_sign_in_path_for(resource)
    params[:return_to] || dashboard_path
  end
end
