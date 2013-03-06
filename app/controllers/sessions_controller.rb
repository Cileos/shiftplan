class SessionsController < Devise::SessionsController
  respond_to :html, :js

  protected

  def after_sign_in_path_for(resource)
    if params[:return_to].present?
      URI.parse(params[:return_to]).path
    else
      stored_location_for(resource) || dynamic_dashboard_path
    end
  end

  # Force Devise to set flash messages on AJAX signin (by session timeout)
  def is_navigational_format?
    request.format == :js || super
  end

end
