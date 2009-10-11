Given /^the following qualifications:$/ do |qualifications|
  qualifications.hashes.each do |qualification_attributes|
    Qualification.create!(qualification_attributes)
  end
end

Then /^I should see a qualification named "([^\"]*)" listed in the sidebar$/ do |name|
  locate_qualification(name).should_not be_nil
end
