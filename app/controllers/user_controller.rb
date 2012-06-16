class UserController < InheritedResources::Base
  load_and_authorize_resource

  def update
    update! { edit_user_path }
  end

  protected

  def resource
    @user ||= current_user
  end

  def update_resource(object, attrs)
    object.update_with_password(*attrs)
  end
end
