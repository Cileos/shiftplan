class SignupController < DeviseController
  include Volksplaner::DeleteAlreadyAuthorizedFlash

  skip_before_filter :authenticate_user!
  skip_authorization_check

  tutorial 'email', only: [:show]

  def show
    authorize! :show, resource
  end

  def create
    authorize! :create, resource
    if resource.valid?
      resource.save!
      set_devise_flash_message resource.user
      redirect_to new_user_session_path
    else
      render action: 'show'
    end
  end

  private

  def resource
    @signup ||= Signup.new resource_params
  end

  def resource_params
    params[:signup]
  end

  # stolen from devise/registration_controller
  def set_devise_flash_message(resource)
    if resource.active_for_authentication?
      set_flash_message :notice, :signed_up if is_navigational_format?
    else
      set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
      expire_data_after_sign_in!
    end
  end

  def devise_i18n_options(options)
    options.tap do |o|
      # do not want to change (structure of) devise locale files
      o[:scope] = 'devise.registrations'
    end
  end

  def permitted_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :remember_me,
      :locale,
      :receive_notification_emails,

      :first_name,
      :last_name,
      :organization_name,
      :account_name
    )
  end
end
