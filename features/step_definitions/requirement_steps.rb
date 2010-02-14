Given /^the following requirements:$/ do |requirements|
  requirements.hashes.each do |attributes|
    workplace = Workplace.find_or_create_by_name(attributes['workplace'])
    start_time, end_time = attributes['start'], attributes['end']
    quantity = attributes['quantity']

    Requirement.create!(
      :workplace => workplace,
      :start => start_time,
      :end => end_time,
      :quantity => quantity
    )
  end
end

When /^I click on the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+)$/ do |qualification, workplace, date|
  element = locate_requirement(date, workplace, qualification)
  click_on(element)
end

When /^I drag the requirement for a "([^\"]*)" from the shift "([^\"]*)" on (.+)$/ do |qualification, workplace, date|
  element = locate_requirement(date, workplace, qualification)
  drag(element)
end

When /^I drop onto the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+)$/ do |qualification, workplace, date|
  element = locate_requirement(date, workplace, qualification)
  drop(element)
end

When /^I drag the assignment of "([^\"]*)" from the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+)$/ do |employee, qualification, workplace, date|
  element = locate_assignment(employee, date, workplace, qualification)
  drag(element)
end


Then /^the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.*) should be highlighted$/ do |qualification, workplace, date|
  locate_requirement(date, workplace, qualification).element['class'].should include('selected')
end

Then /^the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.*) should not be highlighted$/ do |qualification, workplace, date|
  locate_requirement(date, workplace, qualification).element['class'].should_not include('selected')
end

Then /^I should see a requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+)$/ do |qualification, workplace, date|
  locate_requirement(date, workplace, qualification).should_not be_nil
end

Then /^I should not see a requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+)$/ do |qualification, workplace, date|
  lambda { locate_requirement(date, workplace, qualification) }.should raise_error(Steam::ElementNotFound)
end

Then /^I should see the employee "([^\"]*)" assigned to the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+)$/ do |employee, qualification, workplace, date|
  locate_assignment(employee, date, workplace, qualification).should_not be_nil
end

Then /^I should not see the employee "([^\"]*)" assigned to the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+)$/ do |employee, qualification, workplace, date|
  lambda { locate_assignment(employee, date, workplace, qualification) }.should raise_error(Steam::ElementNotFound)
end


Then /^there should be a requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+) stored in the database$/ do |qualification, workplace, date|
  find_requirement(date, workplace, qualification).should_not be_nil
end

Then /^there should not be a requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+) stored in the database$/ do |qualification, workplace, date|
  find_requirement(date, workplace, qualification).should be_nil
end

Then /^the assignment of "([^\"]*)" to the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+) should be stored in the database$/ do |employee, qualification, workplace, date|
  find_assignment(employee, date, workplace, qualification).should_not be_nil
end

Then /^the assignment of "([^\"]*)" to the requirement for a "([^\"]*)" in the shift "([^\"]*)" on (.+) should not be stored in the database$/ do |employee, qualification, workplace, date|
  find_assignment(employee, date, workplace, qualification).should be_nil
end
