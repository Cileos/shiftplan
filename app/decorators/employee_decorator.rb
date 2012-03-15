class EmployeeDecorator < ApplicationDecorator
  decorates :employee

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :employees
      'table#employees'
    else
      super
    end
  end

  def update_employees
    select(:employees).replace_with employees_table
  end

  def employees_table
    h.render('employees/table', employees: h.current_user.organization.employees(true))
  end

  def update_flash
    page['flash'].remove()
    page.select('.navbar:first').after h.render('application/flash')
  end

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