class WelcomeController < ApplicationController
  skip_authorization_check only: :landing
  no_authentication_required only: :landing
  before_filter :authorize_user, only: :dashboard
  before_filter :redirect_to_dashboard_if_signed_in, only: :landing

  def landing
  end

  def dashboard
  end

  protected

  def authorize_user
    authorize! :dashboard, current_user
  end

  def redirect_to_dashboard_if_signed_in
    if user_signed_in?
      redirect_to dashboard_path
    end
  end

end
