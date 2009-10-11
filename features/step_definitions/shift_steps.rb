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

Then /^I should see the following shifts, required qualifications and assignments:$/ do |shifts|
  shifts.hashes.each do |attributes|
    workplace = Workplace.find_by_name(attributes['workplace'])
    
    find_element(:class => 'day', :'data-day' => attributes['date'].gsub('-', '')) do |day|
      find_element(:class => 'shift', :'data-workplace-id' => workplace.id) do |shift|
        attributes['qualifications'].split(',').map(&:strip).each do |qualification|
          qualification_name, assignee_name = qualification.split(':')
          requirement = find_element(:ul) { find_element(:class => 'requirement') }

          unless qualification_name == 'any'
            qualification = Qualification.find_by_name(qualification_name)
            requirement.getClassAttribute.should include("qualification_#{qualification.id}")
          end

          if assignee_name
            assignee = Employee.find_by_name('Clemens Kofler')
            assignment = within(requirement) { find_element(:class => 'assignment') }
            assignment.getClassAttribute.should include("employee_#{assignee.id}")
          end
        end
      end
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
