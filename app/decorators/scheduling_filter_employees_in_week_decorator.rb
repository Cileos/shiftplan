class SchedulingFilterEmployeesInWeekDecorator < SchedulingFilterWeekDecorator
  def cell_metadata(day, employee)
    { employee_id: employee.id, date: day.iso8601 }
  end


  def y_attribute
    :employee
  end
end
