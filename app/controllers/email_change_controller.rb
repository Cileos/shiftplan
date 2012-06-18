class EmailChangeController < InheritedResources::Base
  #custom_actions resource: [:accept, :confirm]

  no_authentication_required
  skip_authorization_check
  before_filter :set_email_change
  before_filter :ensure_not_yet_confirmed
  before_filter :check_current_password, only: :confirm

  def accept

  end

  def confirm
    if @email_change.update_attributes(params[:email_change])
      flash[:notice] = t('email_change.confirm.accepted', email: @email_change.user.email)
      sign_in(User, @email_change.user)
      redirect_to dashboard_path
    else
      render :accept
    end
  end

  private

  def check_current_password
    current_password = params[:email_change][:user_attributes][:current_password]
    unless @email_change.user.valid_password?(current_password)
      @email_change.user.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
    end
  end

  def set_email_change
    unless @email_change = EmailChange.find_by_token(params[:token])
      flash[:alert] = t('email_change.accept.token_invalid')
      redirect_to root_url
    end
  end

  def ensure_not_yet_confirmed
    if @email_change.confirmed?
      if current_user
        flash[:notice] = t('email_change.accept.already_confirmed')
         redirect_to dashboard_path
      else
        flash[:notice] = t('email_change.accept.already_confirmed_log_in')
        redirect_to new_user_session_path
      end
    end
  end
end
