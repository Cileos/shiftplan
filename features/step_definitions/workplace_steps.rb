Given /^the following workplaces:$/ do |workplaces|
  workplaces.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(attributes['account'])
    Workplace.create!(attributes)
  end
end

Then /^I should see a workplace named "([^\"]*)" listed in the sidebar$/ do |name|
  locate_workplace(name).should_not be_nil
end
