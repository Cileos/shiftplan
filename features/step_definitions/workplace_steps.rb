Given /^the following workplaces:$/ do |workplaces|
  workplaces.hashes.each do |workplace_attributes|
    Workplace.create!(workplace_attributes)
  end
end

Then /^I should see a workplace named "([^\"]*)" listed in the sidebar$/ do |name|
  locate_workplace(name).should_not be_nil
end
