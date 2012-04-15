class InvitationsController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  before_filter :set_inviter, only: [:create, :update]

  def create
    create! { respond_with_successful_invitation }
  end

  def update
    update! { respond_with_successful_invitation }
  end

  private

  def set_inviter
    resource.inviter = current_user.current_employee
  end

  def respond_with_successful_invitation
    flash[:info] = t(:'invitations.sent_successfully')
    resource.send_email if resource.errors.empty?
    organization_employees_path(current_organization)
  end

  def begin_of_association_chain
    current_organization
  end
end
