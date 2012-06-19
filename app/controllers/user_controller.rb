class UserController < InheritedResources::Base
  load_and_authorize_resource

  def update
    update! { edit_user_path }
  end

  protected

  def resource
    @user ||= current_user
  end

  # Use devise's method update_with_password for updating the resource.
  # User#update_with_password only updates attributes if :current_password matches, otherwise it returns
  # an error on :current_password.
  # So the user changing his email address/password etc. must always fill in the correct current_password.
  def update_resource(object, attrs)
    object.update_with_password(*attrs)
  end
end
