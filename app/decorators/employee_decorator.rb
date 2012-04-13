class EmployeeDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :employee

  def respond
    unless errors.empty?
      prepend_errors_for(employee)
    else
      hide_modal
      update_employees
      update_flash
    end
  end
end