Given /^the following qualifications:$/ do |qualifications|
  qualifications.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(attributes['account'])
    Qualification.create!(attributes)
  end
end

# TODO: somehow merge this with the above to DRY it up
Given /^the following qualifications for "([^\"]*)":$/ do |account, qualifications|
  qualifications.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(account)
    Qualification.create!(attributes)
  end
end


Then /^I should see a qualification named "([^\"]*)" listed in the sidebar$/ do |name|
  # locate_qualification(name).should_not be_nil
  locate_qualification(name).nil?.should == false
end
