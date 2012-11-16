Then /^the selected "([^"]*)" should be "([^"]*)"$/ do |field, value|
  selected = field_labeled(field).all('option').find {|f| f['selected'] }
  selected.should be_present
  selected.text.should =~ /#{value}/
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
  rescue Selenium::WebDriver::Error::ObsoleteElementError => gone
    # was Selenium::WebDriver::Error::StaleElementReferenceError in previous version
    # Element does not exist in cache => OK
  end
end

Then /^(.+) should be visible/ do |name|
  step %Q~I wait for #{name} to appear~
end

Then /^(.+) should appear/ do |name|
  step %Q~I wait for #{name} to appear~
end

Then /^(.+) should not appear/ do |name|
  # Wait here for a few milliseconds because the following step could
  # accidentally pass because the modal box has not appeared yet.
  sleep 0.5
  step %Q~I wait for #{name} to disappear~
end

Then /^(.+) should disappear$/ do |name|
  step %Q~I wait for #{name} to disappear~
end

When /^I close the modal box$/ do
  page.first('a.ui-dialog-titlebar-close').click
  page.should have_no_css('a.ui-dialog-titlebar-close', :visible => true) # implies waiting
end

Then /^I should see the following defined items:$/ do |expected|
  found = page.all('dl di').map { |di| di.all('dt,dd').map(&:text).map(&:strip) }
  expected.diff! found
end

Then /^the #{capture_quoted} field should be empty$/ do |field|
  wait_until do
    find_field(field).value.empty?
  end
  find_field(field).value.should be_empty
end

Then /^the #{capture_quoted} tab should be active$/ do |tab_name|
  page.should have_css('.nav-tabs li.active', text: tab_name)
end

Then /^(.*) should be removed from the dom$/ do |name|
  page.should have_no_css( selector_for(name) )
end


Then /^I should see the following typeahead items:$/ do |expected|
  list = selector_for('the typeahead list')
  page.should have_css(list)
  found = page.first(list).all('li').map do |li|
    [li.text, li[:class].split.sort.join(' ')]
  end
  expected.diff! found
end

When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^(?:|I )follow "([^"]*)" and confirm$/ do |link|
  click_link(link)
  step 'I confirm popup'
end

Then /^the select field for "(.*?)" should have the following options:$/ do |label, table|
  select_field = find_field(label)
  options = table.raw.map &:first
  options.count.should == select_field.all('option').count
  table.raw.map(&:first).each do |option|
    select_field.has_css?('option', :text => option).should be_true
  end
end

When /^I click on (the #{match_nth}\s?\w+\s?\w+)(?!within.*)$/ do |name|
  selector = selector_for(name)
  page.should have_css(selector)
  page.first( selector ).click
end

When /^I check the checkbox$/ do
  page.first('input[type=checkbox]').click()
end

Then /^the (.+) should( not)? be disabled$/ do |name, negate|
  selector = selector_for(name)
  elem = page.first(selector)
  disabled = elem['disabled']
  if negate
    disabled.should be_in(["false", nil])
  else
    disabled.should be_in(%w(true disabled))
  end
end

