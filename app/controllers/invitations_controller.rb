class InvitationsController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  def create
    create! { respond_with_successful_invitation }
  end

  def update
    update! { respond_with_successful_invitation }
  end

  private

  def respond_with_successful_invitation
    flash[:notice] = t(:'invitations.sent_successfully')
    resource.send_email if resource.errors.empty?
    account_organization_employees_path(current_account, current_organization)
  end

  def begin_of_association_chain
    current_organization
  end
end
