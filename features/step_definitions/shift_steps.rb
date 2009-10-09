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

Then /^I should see the following shifts, required qualifications and assignments:$/ do |shifts|
  shifts.hashes.each do |attributes|
    find_element(:class => 'day', :'data-day' => attributes['date'].gsub('-', '')) do |day|
      workplace = Workplace.find_by_name(attributes['workplace'])
      
      find_element(:'data-workplace-id' => workplace.id) do |shift|
        attributes['qualifications'].split(',').map(&:strip).each do |qualification|
          qualification_name, assignee_name = qualification.split(':')
          
          # FIXME
          # unless qualification_name == 'any'
          #   qualification = Qualification.find_by_name(qualification_name)
          #   find_element(:id => "qualification_#{qualification.id}").should_not be_nil
          # end
        end
      end
    end
  end
end
