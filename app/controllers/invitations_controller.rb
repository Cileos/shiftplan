class InvitationsController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  before_filter :set_inviter, only: [:create, :update]

  def create
    create!(:notice => t(:'invitations.sent_successfully')) do
      respond_with_successful_invitation
    end
  end

  def update
    update!(:notice => t(:'invitations.sent_successfully')) do
      respond_with_successful_invitation
    end
  end

  def accept
    if params[:token] && @invitation = Invitation.find_by_token(params[:token])
      if @invitation.user.confirmed? && @invitation.user.encrypted_password?
        @invitation.update_attributes!(accepted_at: Time.now)
        respond_with_successful_confirmation
      else
        render :accept
      end
    else
      flash[:alert] = t(:'invitations.token_invalid')
      redirect_to root_url
    end
  end

  def confirm
    if @invitation = Invitation.find_by_token(params[:invitation][:token])
      if @invitation.update_attributes(params[:invitation].except(:token))
        respond_with_successful_confirmation
      else
        render :accept
      end
    end
  end

  private

  def set_inviter
    resource.inviter = current_user.current_employee
  end

  def respond_with_successful_confirmation
    flash[:notice] = t(:'invitations.accepted')
    sign_in(User, @invitation.user)
    redirect_to dashboard_path
  end

  def respond_with_successful_invitation
    resource.send_email
    organization_employees_path(current_organization)
  end

  def begin_of_association_chain
    current_organization
  end
end
