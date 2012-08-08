class WelcomeController < ApplicationController
  skip_authorization_check only: :landing
  skip_before_filter :authenticate_user!, only: :landing
  before_filter :authorize_user, only: :dashboard
  before_filter :check_for_multiple_organizations, only: :dashboard

  def landing
  end

  def dashboard
  end

  protected

  def authorize_user
    authorize! :dashboard, current_user
  end

  def check_for_multiple_organizations
    if current_user.organizations.count == 1
      flash.keep
      redirect_to [current_user.organizations.first]
    end
  end
end
