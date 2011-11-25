class WelcomeController < ApplicationController
  def landing
  end

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

end
