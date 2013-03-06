class InvitationDecorator < RecordDecorator
  include EmployeeBaseDecorator
  decorates :invitation

  protected

  def resource
    invitation
  end
end
