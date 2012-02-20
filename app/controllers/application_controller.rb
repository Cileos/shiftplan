class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = translate('message.access_denied')
    respond_to do |denied|
      denied.html { redirect_to root_url }
      denied.js   { render 'denied' }
    end
  end

  check_authorization :unless => :devise_controller?
end
