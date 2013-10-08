class WelcomeController < ApplicationController
  before_filter :authorize_user, only: :dashboard
  before_filter :redirect_to_dynamic_dashboard_if_signed_in, only: :landing

  def landing
  end

  def dashboard
    @upcoming      = current_user.schedulings.upcoming.starting_in_the_next('14 days')
    @notifications = current_user.notifications
    @posts         = current_user.posts_of_joined_organizations.recent(15)

    UserConflictFinder.new(@upcoming).call
  end

  protected

  def authorize_user
    current_user.setup if user_signed_in?
    authorize! :dashboard, current_user
  end

  def redirect_to_dynamic_dashboard_if_signed_in
    unless flash[:alert] # no redirect loop on access denied
      flash.keep
      redirect_to dynamic_dashboard_path
    end
  end

end
