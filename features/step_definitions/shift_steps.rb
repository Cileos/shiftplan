Given /^the following shifts:$/ do |shifts|
  shifts.hashes.each do |attributes|
    plan = Plan.find_or_create_by_name(attributes['plan'])
    workplace = Workplace.find_or_create_by_name(attributes['workplace'])
    start, duration = attributes['start'], attributes['duration']
    reformat_date!(start)

    shift = Shift.create!(
      :plan => plan,
      :workplace => workplace,
      :start => start,
      :end => Time.parse(start) + duration.to_i.minutes
    )

    attributes['requirements'].split(',').each do |requirement|
      qualification, name = requirement.strip.split(':')

      qualification = Qualification.find_by_name(qualification)
      assignee = if name
        first_name, last_name = name.split(' ')
        Employee.find_by_first_name_and_last_name(first_name, last_name)
      end

      shift.requirements.create!(:qualification => qualification, :assignee => assignee)
    end
  end
end

When /^I click on the shift "([^\"]*)" on (.+)$/ do |workplace, date|
  click_on locate_shift(date, workplace)
end

When /^I drop onto to the shift "([^\"]*)" on (.+)$/ do |workplace, date|
  element = locate_shift(date, workplace)
  drop(element)
end

When /^I follow "([^\"]*)" within the shift "([^\"]*)" on (.+)/ do |link, workplace, date|
  locate_shift(date, workplace) do
    click_link(link)
  end
end

When /^I drag the shift "([^\"]*)" on (.*)$/ do |workplace, date|
  element = locate_shift(date, workplace)
  drag(element)
end

When /^I drop onto the shifts area for the workplace "(.*)" on (.*)$/ do |workplace, date|
  shifts = locate_shifts(date)
  drop(shifts)
end

Then /^I should see the following shifts, required qualifications and assignments:$/ do |shifts|
  shifts.hashes.each do |attributes|
    date, workplace, qualifications = attributes.values_at('date', 'workplace', 'qualifications')
    qualifications.split(',').map(&:strip).each do |qualification|
      qualification, assignee = qualification.split(':')
      element = assignee ?
        locate_assignment(assignee, date, workplace, qualification) :
        locate_requirement(date, workplace, qualification)
      element.should_not be_nil
    end
  end
end

Then /^the shift "([^\"]*)" on (.*) should be highlighted$/ do |workplace, date|
  locate_shift(date, workplace).element['class'].should include('selected')
end

Then /^the shift "([^\"]*)" on (.*) should not be highlighted$/ do |workplace, date|
  locate_shift(date, workplace).element['class'].should_not include('selected')
end

Then /^I should see a shift "([^\"]*)" on (.*)$/ do |workplace, date|
  locate_shift(date, workplace).should_not be_nil
end

Then /^I should not see a shift "([^\"]*)" on (.*)$/ do |workplace, date|
  lambda { locate_shift(date, workplace) }.should raise_error(Steam::ElementNotFound)
end

Then /^there should be (a|[\d]*) shifts? "([^\"]*)" on (.*) stored in the database$/ do |count, workplace, date|
  shifts = find_shifts(date, workplace)
  count = count == 'a' ? 1 : count.to_i
  shifts.size.should == count
end

Then /^there should not be a shift "([^\"]*)" on (.*) stored in the database$/ do |workplace, date|
  find_shift(date, workplace).should be_nil
end

Then /^the shift "([^\"]*)" on (.*) should be marked unsuitable$/ do |workplace, date|
  shift = locate_shift(date, workplace)
  shift.attribute('class').should match(/unsuitable_workplace/)
end

Then /^the shift "([^\"]*)" on (.*) should not be marked unsuitable$/ do |workplace, date|
  shift = locate_shift(date, workplace)
  shift.attribute('class').should_not match(/unsuitable_workplace/)
end

Then /^no shifts should be marked as unsuitable$/ do
  response.body.join.should_not match(/unsuitable_workplace/)
end
