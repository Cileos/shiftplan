class SchedulingFilterEmployeesInWeekDecorator < SchedulingFilterWeekDecorator
  def cell_metadata(day, employee)
    { :'employee-id' => employee.try(:id) || 'missing', :date => day.iso8601 }
  end


  def y_attribute
    :employee
  end
end
