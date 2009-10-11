Given /^the following employees:$/ do |employees|
  employees.hashes.each do |attributes|
    first_name, last_name = attributes['name'].split(' ')
    
    qualifications = attributes['qualifications'].split(',').map(&:strip).map do |name| 
      Qualification.find_by_name(name)
    end if attributes.has_key?('qualifications')
    
    Employee.create!(
      :first_name => first_name, 
      :last_name => last_name, 
      :initials => attributes[:initials],
      :qualifications => qualifications
    )
  end
end

Then /^I should see an employee named "([^\"]*)" listed in the sidebar$/ do |name|
  locate_employee(name).should_not be_nil
end
