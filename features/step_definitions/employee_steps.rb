Given /^the following employees:$/ do |employees|
  employees.hashes.each do |attributes|
    attributes = attributes.dup

    attributes['account'] = Account.find_by_name(attributes['account'])
    attributes['first_name'], attributes['last_name'] = attributes.delete('name').split(' ')

    attributes['qualifications'] = attributes['qualifications'].split(',').map(&:strip).map do |name|
      Qualification.find_by_name(name)
    end if attributes.has_key?('qualifications')
    qualifications ||= []

    attributes['initials'] = attributes.delete('initials')

    Employee.create!(attributes)
  end
end

# TODO: somehow merge this with the above to DRY it up
Given /^the following employees for "([^\"]*)":$/ do |account, employees|
  employees.hashes.each do |attributes|
    attributes = attributes.dup

    attributes['account'] = Account.find_by_name(account)
    attributes['first_name'], attributes['last_name'] = attributes.delete('name').split(' ')

    attributes['qualifications'] = attributes['qualifications'].split(',').map(&:strip).map do |name|
      Qualification.find_by_name(name)
    end if attributes.has_key?('qualifications')
    qualifications ||= []

    attributes['initials'] = attributes.delete('initials')

    Employee.create!(attributes)
  end
end

When /I drag the employee "([^\"]*)" over the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.*)$/ do |name, qualification, workplace, date|
  requirement = locate_requirement(date, workplace, qualification)
  requirement.should_not be_nil
  employee = locate_employee(name) { locate(:div) }
  employee.should_not be_nil
  drag(employee, :over => requirement)
end

Then /^I should see the following employees:$/ do |employees|
  employees.hashes.each do |attributes|
    employee = Employee.find_by_name(attributes['name'])
    employee.should_not be_nil
    locate("employee_#{employee.id}").should_not be_nil
  end
end

Then /^I should get a CSV file containing the following employees:$/ do |employees|
  # NOTE: don't forget this only works with hacked steam (TextPage vs. HtmlPage)

  lines = FasterCSV.parse(response.body, :col_sep => ';')#, :headers => true)
  lines.size.should == employees.hashes.size

  employees.hashes.each do |attributes|
    values = attributes.delete('name').split

    lines.any? do |line|
      values.all? { |value| line.include?(value) }
    end.should be_true
  end
end

Then /^the employees should have the following statuses:$/ do |employees|
  employees.hashes.each do |attributes|
    locate_employee(attributes['employee']).element['class'].should include(attributes['status'])
  end
end

Then /^the employees should not have the following statuses:$/ do |employees|
  employees.hashes.each do |attributes|
    locate_employee(attributes['employee']).element['class'].should_not include(attributes['status'])
  end
end

Then /^I should see an employee named "([^\"]*)" listed in the sidebar$/ do |name|
  locate_employee(name).should_not be_nil
end
