# Given /^I am on (.+)$/ do |path|
#   $browser.goto(@host + path_to(path))
#   assert_successful_response
# 
#   $browser.wait # transparently handle AJAX requests
# end
# 
# When /^I fill in "(.*)" with "(.*)"$/ do |field, value|
#   $browser.text_field(:id, find_label(field).for).set(value)
# end