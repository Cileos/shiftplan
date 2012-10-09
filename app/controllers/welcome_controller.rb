class WelcomeController < ApplicationController
  skip_authorization_check only: :landing
  no_authentication_required only: :landing
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
    if user_signed_in?
      flash.keep
      redirect_to dynamic_dashboard_path
    end
  end

end
