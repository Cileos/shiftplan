class UserController < BaseController
  protected

  def resource
    @user ||= current_user
  end
end
