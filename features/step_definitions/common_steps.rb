# If this file becomes to big, please consider tidying it up by splitting into
# other steps files

# Time
Given /^today is (.+)$/ do |timey|
  Timecop.travel Time.parse(timey)
end

When /^I wait for (.+) to appear$/ do |name|
  selector = selector_for name
  wait_until { page.has_css?(selector, :visible => true) }
end

When /^I wait for (.+) to disappear$/ do |name|
  selector = selector_for name
  wait_until { page.has_no_css?(selector, :visible => true) }
end
