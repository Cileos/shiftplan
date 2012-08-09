class Planners::RegistrationsController < Devise::RegistrationsController
  after_filter :setup_user, :only => :create

  protected

  def setup_user
    resource.setup
  end
end

