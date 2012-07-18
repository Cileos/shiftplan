When /^I (accept|dismiss) the popup$/ do |accept_or_dismiss|
  page.driver.browser.switch_to.alert.send(accept_or_dismiss)
end

Then /^I should see #{capture_quoted} in the alert box$/ do |dialog_text|
  page.driver.browser.switch_to.alert.text.should == dialog_text
end

