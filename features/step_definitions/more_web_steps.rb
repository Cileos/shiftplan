Then /^the selected "([^"]*)" should be "([^"]*)"$/ do |field, value|
  field_labeled(field).native.xpath(".//option[@selected = 'selected']").inner_html.should =~ /#{value}/
end

When /^I wait for (.+) to appear$/ do |name|
  selector = selector_for name
  begin
    wait_until { page.has_css?(selector, :visible => true) }
  rescue Capybara::TimeoutError => timeout
    STDERR.puts "saved page: #{save_page}"
    STDERR.puts "saved screenshot: #{screenshot}"
    raise timeout
  end
end

When /^I wait for (.+) to disappear$/ do |name|
  selector = selector_for name
  begin
    wait_until { page.has_no_css?(selector, :visible => true) }
  rescue Capybara::TimeoutError => timeout
    STDERR.puts "saved page: #{save_page}"
    STDERR.puts "saved screenshot: #{screenshot}"
    raise timeout
  rescue Selenium::WebDriver::Error::StaleElementReferenceError => gone
    # Element does not exist in cache => OK
  end
end

Then /^(.+) should be visible/ do |name|
  step %Q~I wait for #{name} to appear~
end

Then /^(.+) should disappear$/ do |name|
  step %Q~I wait for #{name} to disappear~
end

Then /^I should see the following defined items:$/ do |expected|
  found = page.all('dl di').map { |di| di.all('dt,dd').map(&:text).map(&:strip) }
  expected.diff! found
end

