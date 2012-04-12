class InvitationsController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  before_filter :set_inviter, only: [:create, :update]
  before_filter :ensure_no_duplicates, only: [:create, :update]

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
    if request.get?
      if params[:token] && @invitation = Invitation.find_by_token(params[:token])
        user = User.find_by_email(@invitation.email)
        if user.present? && user.confirmed?
          @invitation.update_attributes!(user: user, accepted_at: Time.now)
          respond_with_successful_confirmation
        else
          @invitation.build_user(confirmed_at: Time.now, email: @invitation.email)
          render :accept
        end
      else
        flash[:alert] = t(:'invitations.token_invalid')
        redirect_to root_url
      end
    elsif request.put?
      if @invitation = Invitation.find_by_token(params[:invitation][:token])
        if @invitation.update_attributes(params[:invitation].except(:token))
          respond_with_successful_confirmation
        else
          render :accept
        end
      end
    end
  end

  private

  def ensure_no_duplicates
    if invitation = current_organization.invitations.find_by_email(resource.email)
      if invitation.employee != resource.employee
        flash[:error] = t(:'invitations.another_employee_already_exists_with_email',
          employee_name: invitation.employee.name, email: resource.email)
        redirect_to organization_employees_path(current_organization)
      end
    end
  end

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
