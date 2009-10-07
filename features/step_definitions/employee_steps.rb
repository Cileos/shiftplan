Given /^the following employees:$/ do |employees|
  employees.hashes.each do |attributes|
    first_name, last_name = attributes['name'].split(' ')
    
    qualifications = attributes['qualifications'].split(',').map(&:strip).map do |name| 
      Qualification.find_by_name(name)
    end if attributes.has_key?('qualifications')

    Employee.create!(:first_name => first_name, :last_name => last_name, :qualifications => qualifications)
  end
end