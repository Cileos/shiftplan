Then /^I should be logged in as "([^"]*)"$/ do |email|
  Then %Q~I should see "#{email}" within "#session"~
end
