Given /^the following employees:$/ do |employees|
  employees.hashes.each do |attributes|
    first_name, last_name = attributes['name'].split(' ')
    Employee.create!(:first_name => first_name, :last_name => last_name)
  end
end