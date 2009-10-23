Given /^the following qualifications:$/ do |qualifications|
  qualifications.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(attributes['account'])
    Qualification.create!(attributes)
  end
end

Then /^I should see a qualification named "([^\"]*)" listed in the sidebar$/ do |name|
  locate_qualification(name).should_not be_nil
end
