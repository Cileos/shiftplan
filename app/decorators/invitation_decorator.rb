class InvitationDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :invitation

  protected

  def resource
    invitation
  end
end
