# If this file becomes to big, please consider tidying it up by splitting into
# other steps files

# Time
Given /^today is (.+)$/ do |timey|
  Timecop.travel Time.parse(timey)
end

When /^I wait for (.+) to appear$/ do |name|
  selector = selector_for name
  begin
    wait_until { page.has_css?(selector, :visible => true) }
    wait_until { page.has_css?('#lol', :visible => true) }
  rescue Capybara::TimeoutError => timeout
    STDERR.puts "saved page: #{save_page}"
    raise timeout
  end
end

When /^I wait for (.+) to disappear$/ do |name|
  selector = selector_for name
  begin
    wait_until { page.has_no_css?(selector, :visible => true) }
  rescue Capybara::TimeoutError => timeout
    STDERR.puts "saved page: #{save_page}"
    raise timeout
  end
end
