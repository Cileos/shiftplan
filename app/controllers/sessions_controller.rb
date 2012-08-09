class SessionsController < Devise::SessionsController

  protected

  def after_sign_in_path_for(resource)
    params[:return_to] || dynamic_dashboard_path
  end

  def dynamic_dashboard_path
    if current_user.organizations.count == 1
      current_user.organizations.first
    else
      dashboard_path
    end
  end

end
