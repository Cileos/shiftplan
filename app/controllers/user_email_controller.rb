class UserEmailController < InheritedResources::Base
  defaults :resource_class => User, :instance_name => 'user'
  load_and_authorize_resource class: User

  before_filter :check_for_same_email, only: :update

  # TODO: move this to EmailChangeController#create
  def update
    update! do |success, failure|
      success.html do
        set_flash :notice
        redirect_to change_email_path
        send_confirmation_mail
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
    object.update_with_password(*attrs)
  end

  private

  def send_confirmation_mail
    if email_change = resource.email_change
      email_change.send_confirmation_mail
    end
  end

  def check_for_same_email
    if params[:user][:email] == resource.email
      set_flash :alert, :same_email, email: params[:user][:email]
      redirect_to change_email_path
    end
  end

  def permitted_params
    params.permit user: [
      :email,
      :current_password,
    ]
  end
end
