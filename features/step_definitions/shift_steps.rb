Given /^the following shifts:$/ do |shifts|
  shifts.hashes.each do |attributes|
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
      :workplace => workplace,
      :requirements => requirements,
      :start => start,
      :end => Time.parse(start) + duration.to_i.minutes
    )
  end
end