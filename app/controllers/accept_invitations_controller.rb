class AcceptInvitationsController < InheritedResources::Base
  skip_authorization_check
  before_filter :set_invitation, only: [:accept, :confirm]
  before_filter :ensure_not_yet_accepted, only: [:accept, :confirm]

  def accept
    user = User.find_by_email(@invitation.email)
    if user.present?
      @invitation.update_attributes!(user: user)
      if user.confirmed?
        @invitation.update_attributes!(accepted_at: Time.now)
        respond_with_successful_confirmation
      else
        render :accept
      end
    else
      @invitation.build_user(email: @invitation.email)
      render :accept
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
      redirect_to root_url
    end
  end

  def ensure_not_yet_accepted
    if @invitation.accepted?
      if current_user
        flash[:notice] = t(:'invitations.already_accepted')
        redirect_to dashboard_path
      else
        flash[:notice] = t(:'invitations.already_accepted_log_in')
        redirect_to new_user_session_path
      end
    end
  end

  def respond_with_successful_confirmation
    flash[:notice] = t(:'invitations.accepted')
    sign_in(User, @invitation.user)
    redirect_to dashboard_path
  end
end
