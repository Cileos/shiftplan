Given /^the following plans:$/ do |plans|
  plans.hashes.each do |attributes|
    Plan.create!(attributes)
  end
end


Then /^I should see an employee named "([^\"]*)" listed in the sidebar$/ do |arg1|
  pending
end

Then /^I should see a workplace named "([^\"]*)" listed in the sidebar$/ do |arg1|
  pending
end

Then /^I should see a qualification named "([^\"]*)" listed in the sidebar$/ do |arg1|
  pending
end
