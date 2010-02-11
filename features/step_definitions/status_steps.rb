Given /^the following default statuses:$/ do |statuses|
  statuses.hashes.each do |attributes|
    attributes[:employee]    = Employee.find_by_name(attributes.delete('employee'))
    attributes[:day_of_week] = I18n.t(:'date.day_names').index(attributes.delete('day of week'))
    Status.create!(attributes)
  end
end

# TODO refactor
Then /^the employee "([^\"]*)" should be available on "(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day_of_week, start_time, end_time|
  employee = Employee.find_by_name(employee)
  default_status = employee.statuses.default.detect do |da|
    I18n.t(:'date.day_names')[da.day_of_week] == day_of_week &&
    da.start.strftime('%H:%M') == start_time &&
    da.end.strftime('%H:%M') == end_time
  end
  # default_status.should_not be_nil
  # default_status.should be_available
  default_status.nil?.should == false
  default_status.available?.should == true
  # TODO add DOM expectations
end

Then /^the employee "([^\"]*)" should be unavailable on "(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day_of_week, start_time, end_time|
  employee = Employee.find_by_name(employee)
  default_status = employee.statuses.default.detect do |da|
    I18n.t(:'date.day_names')[da.day_of_week] == day_of_week &&
    da.start.strftime('%H:%M') == start_time &&
    da.end.strftime('%H:%M') == end_time
  end
  # default_status.should_not be_nil
  # default_status.should be_unavailable
  default_status.nil?.should == false
  default_status.unavailable?.should == true
  # TODO add DOM expectations
end

Then /^the employee "([^\"]*)" should be available on "(\d[^\"]*)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day, start_time, end_time|
  employee = Employee.find_by_name(employee)
  status = employee.statuses.override.detect do |status|
    status.day == Date.parse(day) &&
    status.start.strftime('%H:%M') == start_time &&
    status.end.strftime('%H:%M') == end_time
  end
  # status.should_not be_nil
  # status.should be_available
  status.nil?.should == false
  status.available?.should == true
  # TODO add DOM expectations
end

Then /^the employee "([^\"]*)" should be unavailable on "(\d[^\"]*)" from "([^\"]*)" to "([^\"]*)"$/ do |employee, day, start_time, end_time|
  employee = Employee.find_by_name(employee)
  status = employee.statuses.override.detect do |status|
    status.day == Date.parse(day) &&
    status.start.strftime('%H:%M') == start_time &&
    status.end.strftime('%H:%M') == end_time
  end
  # status.should_not be_nil
  # status.should be_unavailable
  status.nil?.should == false
  status.unavailable?.should == true
  # TODO add DOM expectations
end
