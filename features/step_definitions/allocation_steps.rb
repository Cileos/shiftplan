Given /^the following allocations:$/ do |allocations|
  allocations.hashes.each do |attributes|
    first_name, last_name = attributes['employee'].split(' ')
    employee = Employee.find_or_create_by_first_name_and_last_name(first_name, last_name)
    workplace = Workplace.find_or_create_by_name(attributes['workplace'])
    Allocation.create!(
      :employee => employee,
      :workplace => workplace,
      :start => attributes['start'],
      :end => attributes['end']
    )
  end
end