class EmailChangeController < InheritedResources::Base
  #custom_actions resource: [:accept, :confirm]

  no_authentication_required
  skip_authorization_check
  before_filter :set_email_change
  before_filter :set_user
  before_filter :ensure_not_yet_confirmed

  def accept
  end

  def confirm
    if @user.update_with_password(params[:user])
      flash[:notice] = t('email_change.confirm.accepted', email: @user.email)
      sign_in(User, @user)
      redirect_to dashboard_path
    else
      flash[:alert] = t('email_change.confirm.rejected', email: @user.email)
      render :accept
    end
  end

  private

  def set_email_change
    unless @email_change = EmailChange.find_by_token(params[:token])
      flash[:alert] = t('email_change.accept.token_invalid')
      redirect_to root_url
    end
  end

  def set_user
    @user = @email_change.user
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
