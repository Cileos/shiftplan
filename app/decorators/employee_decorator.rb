class EmployeeDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :employee

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :avatar_and_name
      'span#avatar_and_name'
    else
      super
    end
  end

  def respond
    unless errors.empty?
      prepend_errors_for(resource)
    else
      hide_modal
      update_employees
      if resource == h.current_employee
        h.current_employee.reload
        update_avatar_and_name
      end
      update_flash
    end
  end

  def update_avatar_and_name
    select(:avatar_and_name).replace_with h.render('application/avatar_and_name')
  end

  protected

  def resource
    employee
  end
end
