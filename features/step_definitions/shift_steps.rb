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

Then /^I should see a shift for the (.*) on ([\d-]*), starting at ([\d:]*), lasting ([\d]*) minutes, containing ([\d]*) requirements? for (?:(any) qualification|a (.*))(?: and an assignment for ([\w ]*))?$/ do |workplace, date, time, duration, requirements_count, qualification, *assignee|
  # p workplace, date, time, duration, requirements_count, qualification, assignee
  date = date.gsub('-', '')
  day = page.getByXPath(%(html/body//*[@data-day="#{date}"])).get(0)
  day.should_not be_nil
  
  shift = within(day) do
    find_element()
  end
#    find_element(workplace).should_not be_nil
  
end
