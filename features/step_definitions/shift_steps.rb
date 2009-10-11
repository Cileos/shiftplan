Given /^the following shifts:$/ do |shifts|
  shifts.hashes.each do |attributes|
    plan = Plan.find_or_create_by_name(attributes['plan'])
    workplace = Workplace.find_or_create_by_name(attributes['workplace'])
    start, duration = attributes['start'], attributes['duration']
    reformat_date!(start)

    requirements = attributes['requirements'].split(',').map do |requirement|
      qualification, name = requirement.strip.split(':')

      qualification = Qualification.find_by_name(qualification)
      assignee = if name
        first_name, last_name = name.split(' ')
        Employee.find_by_first_name_and_last_name(first_name, last_name)
      end

      Requirement.create!(:qualification => qualification, :assignee => assignee)
    end

    Shift.create!(
      :plan => plan,
      :workplace => workplace,
      :requirements => requirements,
      :start => start,
      :end => Time.parse(start) + duration.to_i.minutes
    )
  end
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

When /^I drag the shift "([^\"]*)" on (.*)$/ do |workplace, date|
  element = locate_shift(date, workplace)
  drag(element)
end

When /^I drop onto the shifts area for day (.*)$/ do |date|
  element = locate_shifts(date)
  drop(element)
end

Then /^I should see a shift "([^\"]*)" on (.*)$/ do |workplace, date|
  locate_shift(date, workplace).should_not be_nil
end

Then /^I should not see a shift "([^\"]*)" on (.*)$/ do |workplace, date|
  locate_shift(date, workplace).should be_nil
end

Then /^there should be a shift "([^\"]*)" on (.*) stored in the database$/ do |workplace, date|
  find_shift(date, workplace).should_not be_nil
end

Then /^there should not be a shift "([^\"]*)" on (.*) stored in the database$/ do |workplace, date|
  find_shift(date, workplace).should be_nil
end
