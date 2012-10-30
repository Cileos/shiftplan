class WelcomeController < ApplicationController
  skip_authorization_check only: :landing
  skip_before_filter :authenticate_user!, only: :landing
  before_filter :authorize_user, only: :dashboard
  before_filter :redirect_to_dynamic_dashboard_if_signed_in, only: :landing

  def landing
  end

  def dashboard
  end

  protected

  def authorize_user
    current_user.setup if user_signed_in?
    authorize! :dashboard, current_user
  end

  def redirect_to_dynamic_dashboard_if_signed_in
    if user_signed_in? and not flash[:alert] # no redirect loop on access denied
      flash.keep
      redirect_to dynamic_dashboard_path
    end
  end

end
