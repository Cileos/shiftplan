Given /^the following default statuses:$/ do |statuses|
  statuses.hashes.each do |attributes|
    attributes[:employee]    = Employee.find_by_name(attributes.delete('employee'))
    attributes[:day_of_week] = I18n.t(:'date.day_names').index(attributes.delete('day of week'))
    Status.create!(attributes)
  end
end

Given /^the following statuses:$/ do |statuses|
  statuses.hashes.each do |attributes|
    attributes[:employee] = Employee.find_by_name(attributes.delete('employee'))
    Status.create!(attributes)
  end
end

Given /^the employee "([^\"]*)" is "([^\"]*)" on (.*)$/ do |employee, status, day|
  reformat_date!(day)
  Status.create!(:employee => Employee.find_by_name(employee), :status => status, :day => day)
end

Given /^the employee "([^\"]*)" is "([^\"]*)" from "([^\"]*)" to "([^\"]*)" on (.*)$/ do |employee, status, start_time, end_time, day|
  reformat_date!(day)
  start_time, end_time = Time.parse(start_time), Time.parse(end_time)
  Status.create!(:employee => Employee.find_by_name(employee), :status => status, :day => day, :start_time => start_time, :end_time => end_time)
end


# TODO refactor
Then /^the employee "([^\"]*)" should be available on "(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day_of_week, start_time, end_time|
  employee = Employee.find_by_name(employee)
  default_status = employee.statuses.default.detect do |da|
    I18n.t(:'date.day_names')[da.day_of_week] == day_of_week &&
    da.start_time.strftime('%H:%M') == start_time &&
    da.end_time.strftime('%H:%M') == end_time
  end
  default_status.should_not be_nil
  default_status.should be_available
  # TODO add DOM expectations
end

Then /^the employee "([^\"]*)" should be unavailable on "(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day_of_week, start_time, end_time|
  employee = Employee.find_by_name(employee)
  default_status = employee.statuses.default.detect do |da|
    I18n.t(:'date.day_names')[da.day_of_week] == day_of_week &&
    da.start_time.strftime('%H:%M') == start_time &&
    da.end_time.strftime('%H:%M') == end_time
  end
  default_status.should_not be_nil
  default_status.should be_unavailable
  # TODO add DOM expectations
end

Then /^the employee "([^\"]*)" should be available on "(\d[^\"]*)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day, start_time, end_time|
  employee = Employee.find_by_name(employee)
  status = employee.statuses.override.detect do |status|
    status.day == Date.parse(day) &&
    status.start_time.strftime('%H:%M') == start_time &&
    status.end_time.strftime('%H:%M') == end_time
  end
  status.should_not be_nil
  status.should be_available
  # TODO add DOM expectations
end

Then /^the employee "([^\"]*)" should be unavailable on "(\d[^\"]*)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day, start_time, end_time|
  employee = Employee.find_by_name(employee)
  status = employee.statuses.override.detect do |status|
    status.day == Date.parse(day) &&
    status.start_time.strftime('%H:%M') == start_time &&
    status.end_time.strftime('%H:%M') == end_time
  end
  status.should_not be_nil
  status.should be_unavailable
  # TODO add DOM expectations
end

Then /^the employee "([^\"]*)" should have no availability entries for "([^\"]*)"$/ do |employee, day|
  employee = Employee.find_by_name(employee)
  statuses = employee.statuses.override.select { |status| status.day == Date.parse(day) }
  statuses.should be_empty
  # TODO add DOM expectations
end
