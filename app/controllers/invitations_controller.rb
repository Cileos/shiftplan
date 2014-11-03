class InvitationsController < BaseController
  nested_belongs_to :account, :organization

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
    flash[:notice] = t(:'invitations.sent_successfully')
    resource.send_invitation if resource.errors.empty?
    account_organization_employees_path(current_account, current_organization)
  end

  def permitted_params
    params.permit invitation: [
      :employee_id,
      :email,
    ]
  end
end
