class EmployeeDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :employee

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :avatar_and_name
      'span#avatar_and_name'
    when :employee_row
      "tr#employee_#{resource.id}"
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
      scroll_to
      highlight
    end
  end

  protected

  def resource
    employee
  end

  def update_avatar_and_name
    select(:avatar_and_name).replace_with h.render('application/avatar_and_name')
  end

  def scroll_to
    select(:employee_row, resource).scroll_to()
  end

  def highlight
    select(:employee_row, resource).effect('highlight', {}, 3000)
  end
end
