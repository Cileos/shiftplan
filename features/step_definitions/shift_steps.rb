Given /^the following shifts:$/ do |shifts|
  shifts.hashes.each do |attributes|
    plan = Plan.find_or_create_by_name(attributes['plan'])
    workplace = Workplace.find_or_create_by_name(attributes['workplace'])
    start, duration = attributes['start'], attributes['duration']

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

Then /^I should see a shift for the (.*) on ([\d-]*), starting at ([\d:]*), lasting ([\d]*) minutes, containing ([\d]*) requirements? for (?:(any) qualification|a (.*))(?: and an assignment for ([\w ]*))?$/ \
  do |workplace, date, time, duration, requirements_count, qualification, *assignee|

  qualification = Qualification.find_by_name(qualification)
  # assignee = User.find_by_name(assignee)

  find_element(:class => 'day', :'data-day' => date.gsub('-', '')) do
    find_element(:class => /shift/) do
      find_element(workplace).should_not be_nil
      find_element(:class => 'requirement') do |element|
        element.getClassAttribute.should_match /"qualification_#{qualification.id}"/
      end if qualification
      # find_elements(:class => /requirement/).count.should_by requirements_count.to_i
      if assignee
        # TODO
      end
    end
  end
end
