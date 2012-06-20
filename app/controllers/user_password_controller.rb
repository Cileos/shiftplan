class UserPasswordController < InheritedResources::Base
  defaults :resource_class => User, :instance_name => 'user'
  load_and_authorize_resource class: User

  def update
    update! do |success, failure|
      success.html do
        set_flash :info
        redirect_to user_password_path
      end
      failure.html do
        set_flash :alert
        render :show
      end
    end
  end

  protected

  def resource
    @user ||= current_user
  end

  # Use devise's method update_with_password for updating the resource.
  # User#update_with_password only updates attributes if :current_password
  # matches, otherwise it returns an error on :current_password.  So the user
  # changing his email address/password etc. must always fill in the correct
  # current_password.
  def update_resource(object, attrs)
    object.update_with_password(*attrs).tap do
      # As devise will set the current_user to nil after a password change, we
      # log him in again after the update
      sign_in(User, object, bypass: true)
    end
  end
end
