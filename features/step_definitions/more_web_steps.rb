Then /^the selected "([^"]*)" should be "([^"]*)"$/ do |field, value|
  selected = field_labeled(field).all('option').find {|f| f['selected'] }
  selected.should be_present
  selected.text.should =~ /#{value}/
end

Then /^the selected "([^"]*)" of the single-select box should be "([^"]*)"$/ do |field, value|
  select_id = field_labeled(field)["id"]
  selected = page.find("div##{select_id}_chosen a.chosen-single span")
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

Then /^I should not see ([\w ]+)$/ do |name|
  selector = selector_for name
  page.should have_no_css(selector)
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

# When I click on the delete link (or any other human selector for a link)
When /^I follow (the .+ link)$/ do |target|
  selector = selector_for(target)
  page.should have_css(selector)
  page.first(selector).click
end


Then /^the select field for "(.*?)" should have the following options:$/ do |label, expected|
  expected.diff! find_field(label).all('option').map(&:text).map { |label| [label] }
end

When /^I click on (the #{match_nth}\s?\w+\s?\w+)(?!within.*)$/ do |name|
  selector = selector_for(name)
  page.should have_css(selector)
  page.first( selector ).click
end

When /^I click on (.+) with jQuery$/ do |name|
  page.execute_script <<-EOJS
    $("#{selector_for(name)}").click()
  EOJS
end

When /^I check the checkbox$/ do
  check page.first('input[type=checkbox]')['id']
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

When /^(?:|I )fill in the (\d+)(?:st|nd|rd|th) #{capture_quoted} with #{capture_quoted}$/ do |num, name, value|
  all(:xpath, ".//input[@id=//label[contains(.,'#{name}')]/@for]")[num.to_i-1].set(value)
end

# Just checks if the current URL starts with the provided one, ignoring sub-URL parts
#  Then I should be under the page of the plan
Then /^(?:|I )should be somewhere under (.+)$/ do |page_name|
  expected = path_to(page_name)
  begin
    wait_until { URI.parse(current_url).path.starts_with? expected }
  rescue Capybara::TimeoutError => e
    URI.parse(current_url).path.should start_with(expected)
  end
end

# The following steps are inspired by web_steps, but modified to wait a bit (for JS to change the values)

Then /^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = nil
    begin
      wait_until do
        field_value = (field.tag_name == 'textarea') ? field.text : field.value
        field_value =~ /#{value}/
      end
    rescue Capybara::TimeoutError
      field_value.should =~ /#{value}/
    end
  end
end

Then /^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = nil
    begin
      wait_until do
        field_value = (field.tag_name == 'textarea') ? field.text : field.value
        field_value !~ /#{value}/
      end
    rescue Capybara::TimeoutError
      field_value.should_not =~ /#{value}/
    end
  end
end


Then /^the "([^"]*)" field(?: within (.*))? should equal "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should == value
    else
      assert_equal value, field_value
    end
  end
end

Given /^I use an? (german|english|polish) browser$/ do |lang|
  case lang
  when 'english'
    add_headers 'Accept-Language' => 'en-GB'
  when 'german'
    add_headers 'Accept-Language' => 'de-DE'
  when 'polish' # not supported yet
    add_headers 'Accept-Language' => 'pl-PL'
  end
end

Before '~@javascript' do # cannot set headers with selenium
  add_headers 'Accept-Language' => nil # clear
end

module ErrorFieldFinder
  def find_error_field(field_name)
    begin
      field = find_field(field_name)
    rescue Capybara::ElementNotFound => e
      fail %Q~could not find field "#{field_name}"~
    end
    begin
      field.find(:xpath, 'following-sibling::span[@class="error"]')
    rescue Capybara::ElementNotFound => e
      fail %Q~could not find error field for "#{field_name}"~
    end
  end
end

World(ErrorFieldFinder)

Then /^the #{capture_quoted} field should have error #{capture_quoted}$/ do |field_name, expected_error|
  find_error_field(field_name).text.should include(expected_error)
end

Then /^I should see the following validation errors:$/ do |expected_errors|
  found = expected_errors.rows_hash.map do |field, error|
    [
      field,
      (find_error_field(field).text rescue '')
    ]
  end
  expected_errors.diff! found
end

When /^I select "(.*?)" from the "(.*?)" multiple-select box/ do |text,label|
  find("label:contains('#{label}') ~ div.chosen-container").click
  find("div.chosen-container li", text:text).click
end

When /^I select "(.*?)" from the "(.*?)" single-select box/ do |text,label|
  find("label:contains('#{label}') ~ div.chosen-container-single").click
  find("div.chosen-container li.active-result", text:text).click
end

