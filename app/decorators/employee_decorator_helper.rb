module EmployeeDecoratorHelper
  def initialize(*)
    super
    if h.current_organization?
      model.organization_id ||= h.current_organization.id
    end
  end
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
      records: h.current_organization.employees.default_sorting.map(&:decorate))
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
