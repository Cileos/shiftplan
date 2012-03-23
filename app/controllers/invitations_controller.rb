class InvitationsController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  def create
    resource.inviter = current_user.current_employee
    create!(:notice => t(:'invitations.sent_successfully')) do
      organization_employees_path(current_organization)
    end
  end

  def accept
    if params[:token] && @invitation = Invitation.find_by_token(params[:token])
      render :accept
    else
      flash[:alert] = t(:'invitations.token_invalid')
      redirect_to root_url
    end
  end

  def confirm
    if @invitation = Invitation.find_by_token(params[:invitation][:token])
      if @invitation.update_attributes(params[:invitation].except(:token))
        flash[:notice] = t(:'invitations.accepted')
        sign_in(User, @invitation.user)
        redirect_to dashboard_path
      else
        render :accept
      end
    end
  end

  private

  def begin_of_association_chain
    current_organization
  end
end
