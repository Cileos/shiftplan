Then /^the employee "([^\"]*)" should be available on "(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day_of_week, start_time, end_time|
  employee = Employee.find_by_name(employee)
  default_availability = employee.availabilities.default.detect do |da|
    I18n.t(:'date.day_names')[da.day_of_week] == day_of_week &&
    da.start.strftime('%H:%M') == start_time &&
    da.end.strftime('%H:%M') == end_time
  end
  default_availability.should_not be_nil
  # TODO add DOM expectations
end

Then /^the employee "([^\"]*)" should be available on "([^\"]*)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day, start_time, end_time|
  employee = Employee.find_by_name(employee)
  availability = employee.availabilities.override.detect do |availability|
    availability.day == Date.parse(day) &&
    availability.start.strftime('%H:%M') == start_time &&
    availability.end.strftime('%H:%M') == end_time
  end
  availability.should_not be_nil
  # TODO add DOM expectations
end

