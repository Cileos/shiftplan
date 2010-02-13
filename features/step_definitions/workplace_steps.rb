Given /^the following workplaces:$/ do |workplaces|
  workplaces.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(attributes['account'])

    attributes['qualifications'] = attributes['qualifications'].split(',').map do |qualification|
      Qualification.find_by_name(qualification.strip)
    end if attributes.has_key?('qualifications')

    Workplace.create!(attributes)
  end
end

# TODO: somehow merge this with the above to DRY it up
Given /^the following workplaces for "([^\"]*)":$/ do |account, workplaces|
  workplaces.hashes.each do |attributes|
    attributes = attributes.dup
    attributes['account'] = Account.find_by_name(account)

    attributes['qualifications'] = attributes['qualifications'].split(',').map do |qualification|
      Qualification.find_by_name(qualification.strip)
    end if attributes.has_key?('qualifications')

    Workplace.create!(attributes)
  end
end

Then /^I should see a workplace named "([^\"]*)" listed in the sidebar$/ do |name|
  # locate_workplace(name).should_not be_nil
  locate_workplace(name).nil?.should == false
end
