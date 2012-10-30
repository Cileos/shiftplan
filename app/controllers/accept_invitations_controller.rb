class AcceptInvitationsController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_authorization_check
  before_filter :set_invitation, only: [:accept, :confirm]
  before_filter :ensure_not_yet_accepted, only: [:accept, :confirm]
  before_filter :save_or_build_user_on_invition, only: [:accept]

  def accept
    if @invitation.user.confirmed?
      @invitation.update_attributes!(accepted_at: Time.now)
      respond_with_successful_confirmation
    else
      respond_with_accept_by_setting_a_password
    end
  end

  def confirm
    if @invitation.update_attributes(params[:invitation])
      respond_with_successful_confirmation
    else
      render :accept
    end
  end

  private

  def set_invitation
    unless @invitation = Invitation.find_by_token(params[:token])
      flash[:alert] = t(:'invitations.token_invalid')
      redirect_to user_signed_in?? dashboard_url : root_url
    end
  end

  def ensure_not_yet_accepted
    if @invitation.accepted?
      if user_signed_in?
        flash[:notice] = t(:'invitations.already_accepted')
        redirect_to dynamic_dashboard_path
      else
        flash[:notice] = t(:'invitations.already_accepted_log_in')
        redirect_to new_user_session_path
      end
    end
  end

  def save_or_build_user_on_invition
    if user = User.find_by_email(@invitation.email)
      @invitation.update_attributes!(user: user)
    else
      @invitation.build_user(email: @invitation.email)
    end
  end

  def respond_with_successful_confirmation
    flash[:notice] = t(:'invitations.accepted')
    sign_in(User, @invitation.user)
    redirect_to dynamic_dashboard_path
  end

  def respond_with_accept_by_setting_a_password
    flash[:notice] = t(:'invitations.accept_by_setting_a_password')
    render :accept
  end
end
