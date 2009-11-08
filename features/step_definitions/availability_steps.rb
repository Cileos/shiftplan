Then /^the employee "([^\"]*)" should be available on "([^\"]*)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day_of_week, start_time, end_time|
  employee = Employee.find_by_name(employee)
  default_availability = employee.default_availabilities.detect do |da|
    I18n.t(:'date.day_names')[da.day_of_week] == day_of_week &&
    da.start.strftime('%H:%M') == start_time &&
    da.end.strftime('%H:%M') == end_time
  end
  default_availability.should_not be_nil
  # TODO add DOM expectations
end
