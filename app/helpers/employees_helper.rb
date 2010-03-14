module EmployeesHelper
  def initials_for(employee)
    content_tag(:abbr, employee.initials, :title => employee.full_name)
  end
end
