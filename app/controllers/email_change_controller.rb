class EmailChangeController < ApplicationController
  skip_authorization_check
  skip_before_filter :authenticate_user!

  before_filter :set_email_change
  before_filter :set_user
  before_filter :ensure_not_yet_confirmed

  def accept
  end

  def confirm
    if @user.update_with_password(params[:user])
      set_flash(:notice, 'accepted', email: @user.email)
      sign_in(User, @user)
      redirect_to dynamic_dashboard_path
    else
      set_flash(:alert, 'rejected', email: @user.email)
      render :accept
    end
  end

  private

  def set_email_change
    unless @email_change = EmailChange.find_by_token(params[:token])
      set_flash(:alert, 'token_invalid')
      redirect_to dashboard_path
    end
  end

  def set_user
    @user = @email_change.user
  end

  def ensure_not_yet_confirmed
    if @email_change.confirmed?
      if current_user
        set_flash(:alert, 'already_confirmed', action: 'accept')
        redirect_to dynamic_dashboard_path
      else
        set_flash(:alert, 'already_confirmed_sign_in', action: 'accept')
        redirect_to new_user_session_path
      end
    end
  end
end
