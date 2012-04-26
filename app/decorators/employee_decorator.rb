class EmployeeDecorator < ApplicationDecorator
  include EmployeeBaseDecorator
  decorates :employee

  def update_employee_in_calendar_view
    update_employee_header
    # update_employee_weekly_working_time
  end

  # TODO update the whole employee row instead
  def update_employee_header
    select(:employee_header, employee).replace_with h.render('schedulings/employee_header', employee: employee)
  end

  # def update_employee_weekly_working_time
  #  select(:employee_weekly_working_time).replace_with h.render('schedulings/employee_weekly_working_time', employee: employee)
  # end
end
