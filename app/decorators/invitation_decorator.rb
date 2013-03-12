class InvitationDecorator < RecordDecorator
  include EmployeeDecoratorHelper
  decorates :invitation

  protected

  def resource
    invitation
  end
end
