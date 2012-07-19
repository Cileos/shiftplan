class UserController < InheritedResources::Base
  load_and_authorize_resource

  protected

  def resource
    @user ||= current_user
  end
end
