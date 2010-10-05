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

Given /^the following employee qualifications and statuses$/ do |table|
  table.hashes.each do |row|
    name, qualification, statuses = row.values_at('name', 'qualification', 'statuses')
    employee = Employee.find_by_name(name)
    statuses.split(',').each do |status|
      day, status = status.split(':')
      reformat_date!(day)
      employee.statuses.create!(:day => day, :start_time => '8:00', :end_time => '17:00', :status => status)
    end
    unless qualification.blank?
      qualification = Qualification.find_by_name(qualification)
      employee.qualifications << qualification
    end
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

Then /^I should not see the following employees:$/ do |employees|
  employees.hashes.each do |attributes|
    Employee.find_by_name(attributes['name']).should be_nil
    lambda { locate(attributes['name']) }.should raise_error(Steam::ElementNotFound)
  end
end

Then /^I should see an employee named "([^\"]*)" listed in the sidebar$/ do |name|
  locate_employee(name).should_not be_nil
end

Then /^the employee "([^\"]*)" should be marked as "([^\"]*)"$/ do |employee, status|
  locate_employee(employee).attribute('class').should have_css_class(status)
end

Then /^the employee "([^\"]*)" should not be marked as "([^\"]*)"$/ do |employee, status|
  locate_employee(employee).attribute('class').should_not have_css_class(status)
end

Then /^I should get a CSV file containing the following employees:$/ do |employees|
  lines = FasterCSV.parse(response.body, :col_sep => ';', :headers => true)
#  lines = CSV.parse(response.body, :col_sep => ';', :headers => true)
  lines.size.should == employees.hashes.size

  employees.hashes.each do |attributes|
    attributes['first_name'], attributes['last_name'] = attributes.delete('name').split

    lines.any? do |line|
      attributes.all? { |name, value| line.field(name) == value }
    end.should be_true
  end
end

Then /^I should get a blank employee CSV file$/ do
  response.body.should == Employee.csv_fields.to_csv(:col_sep => ';')
end