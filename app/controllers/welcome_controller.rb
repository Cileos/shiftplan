class WelcomeController < ApplicationController
  def landing
  end

  before_filter :authenticate_user!, :only => :dashboard
  before_filter :must_be_planner, :only => :dashboard

  def dashboard
  end

  private

  # TODO solve this with cancan or similar authorization framework
  def must_be_planner
    redirect_to root_path unless current_user.is_planner?
  end

end
