Given /^the following qualifications:$/ do |qualifications|
  qualifications.hashes.each do |qualification_attributes|
    Qualification.create!(qualification_attributes)
  end
end

Then /^I should see a qualification named "([^\"]*)" listed in the sidebar$/ do |name|
  qualification = Qualification.find_by_name(name)
  element = find_element('sidebar') { find_element(:href => "/qualifications/#{qualification.id}") }
  element.should_not be_nil
end
