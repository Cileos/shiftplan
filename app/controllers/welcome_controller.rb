class WelcomeController < ApplicationController
  skip_authorization_check only: :landing
  no_authentication_required only: :landing
  before_filter :authorize_user, only: :dashboard
  before_filter :redirect_to_dashboard_if_signed_in, only: :landing
  before_filter :redirect_to_organization_if_only_one, only: :dashboard

  def landing
  end

  def dashboard
  end

  protected

  def authorize_user
    current_user.setup if user_signed_in?
    authorize! :dashboard, current_user
  end

  def redirect_to_dashboard_if_signed_in
    if user_signed_in?
      flash.keep
      redirect_to dashboard_path
    end
  end

  def redirect_to_organization_if_only_one
    if current_user.joined_organizations.count == 1
      first = current_user.joined_organizations.first
      flash.keep
      redirect_to [first.account, first]
    end
  end

end
