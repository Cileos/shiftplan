class WelcomeController < ApplicationController
  def landing
  end

  before_filter :authenticate_user!, :only => :dashboard
  before_filter :must_be_planner, :only => :dashboard

  def dashboard
  end

  private

  before_filter :create_default_organization, :only => :dashboard
  def create_default_organization
    if current_user.is_planner?
      unless current_user.organization.present?
        current_user.organizations.create!
      end
    end
  end

  # TODO solve this with cancan or similar authorization framework
  def must_be_planner
    redirect_to root_path unless current_user.is_planner?
  end

end
