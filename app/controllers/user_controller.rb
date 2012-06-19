class UserController < InheritedResources::Base
  load_and_authorize_resource
  custom_actions resource: [:update_email, :update_password]

  def update_email
    update! do |success, failure|
      success.html do
        flash[:info] = t('flash.user.update_email.info')
        redirect_to edit_user_path
      end
    end
  end

  def update_password
    update! do |success, failure|
      success.html do
        flash[:info] = t('flash.user.update_password.info')
        redirect_to edit_user_path
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
