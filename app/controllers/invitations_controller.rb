class InvitationsController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  def create
    resource.inviter = current_user.current_employee
    create!(:notice => t(:'invitations.invitation_sent_successfully')) do
      organization_employees_path(current_organization)
    end
  end

  def accept
    
  end

  private

  def begin_of_association_chain
    current_organization
  end
end
