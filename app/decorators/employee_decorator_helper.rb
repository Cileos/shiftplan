module EmployeeDecoratorHelper
  def selector_for(name, resource=nil, extra=nil)
    case name
    when :employees
      'div#employees'
    else
      super
    end
  end

  def update_employees
    select(:employees).refresh_html employees_table
  end

  def employees_table
    h.render('employees/table',
      employees: h.current_organization.employees.default_sorting)
  end

  def respond
    unless errors.empty?
      prepend_errors_for(resource)
    else
      clear_modal
      update_employees
      update_flash
    end
  end
end
