class SessionsController < Devise::SessionsController
  respond_to :html, :js

  protected

  def after_sign_in_path_for(resource)
    if params[:return_to].present?
      URI.parse(params[:return_to]).path
    else
      stored_location_for(resource) || dashboard_path
    end
  end
end
