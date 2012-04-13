class InvitationDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :invitation

  def respond
    unless errors.empty?
      prepend_errors_for(invitation)
    else
      send_email
      hide_modal
      update_employees
      update_flash
    end
  end
end