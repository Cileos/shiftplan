Given /^the following workplaces:$/ do |workplaces|
  workplaces.hashes.each do |workplace_attributes|
    Workplace.create!(workplace_attributes)
  end
end

Then /^I should see a workplace named "([^\"]*)" listed in the sidebar$/ do |name|
  workplace = Workplace.find_by_name(name)
  element = find_element('sidebar') { find_element(:href => "/workplaces/#{workplace.id}") }
  element.should_not be_nil
end
