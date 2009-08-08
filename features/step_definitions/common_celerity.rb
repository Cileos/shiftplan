require 'culerity'

# Before do
#   $server ||= Culerity::run_server
#   $browser = Culerity::RemoteBrowserProxy.new($server, :browser => :firefox)
#   $host = 'http://localhost:3001'
# end

at_exit do
  $browser.exit
  $server.close
end

Given /^I am on (.+)$/ do |path|
  $browser.goto $host + path_to(path)
  assert_successful_response
end

When /I press "(.*)"/ do |button|
  $browser.button(:text, button).click
  assert_successful_response
end

When /I follow "(.*)"/ do |link|
  $browser.link(:text, /#{link}/).click
  assert_successful_response
end

When /I fill in "(.*)" with "(.*)"/ do |field, value|
  $browser.text_field(:id, find_label(field).for).set(value)
end

When /I check "(.*)"/ do |field|
  $browser.check_box(:id, find_label(field).for).set(true)
end

When /^I uncheck "(.*)"$/ do |field|
  $browser.check_box(:id, find_label(field).for).set(false)
end

When /I select "(.*)" from "(.*)"/ do |value, field|
  $browser.select_list(:id, find_label(field).for).select value
end

When /I choose "(.*)"/ do |field|
  $browser.radio(:id, find_label(field).for).set(true)
end

When /I go to (.+)/ do |path|
  $browser.goto $host + path_to(path)
  assert_successful_response
end

When /I wait for the AJAX call to finish/ do
  $browser.wait
end

Then /I should see "(.*)"/ do |text|
  # if we simply check for the browser.html content we don't find content that has been added dynamically, e.g. after an ajax call
  div = $browser.div(:text, /#{text}/)
  begin
    div.html
  rescue
    #puts $browser.html
    raise("div with '#{text}' not found")
  end
  # elements = $browser.elements_by_xpath("//*") # TODO: improve xPath to only check descendants of /html/body
  # elements.any? { |element| eval(element.gsub('@io', '$server')).try(:text) == text rescue false }.should be_true
end

Then /I should not see "(.*)"/ do |text|
  div = $browser.div(:text, /#{text}/).html rescue nil
  div.should be_nil
  # elements = $browser.elements_by_xpath("//*") # TODO: improve xPath to only check descendants of /html/body
  # elements.any? { |element| eval(element.gsub('@io', '$server')).try(:text) == text rescue false }.should be_false
end

def find_label(text)
  $browser.label :text, text
end

def assert_successful_response
  status = $browser.page.web_response.status_code
  if(status == 302 || status == 301)
    location = $browser.page.web_response.get_response_header_value('Location')
    puts "Being redirected to #{location}"
    $browser.goto location
    assert_successful_response
  elsif status != 200
    tmp = Tempfile.new 'culerity_results'
    tmp << $browser.html
    `open -a /Applications/Safari.app #{tmp.path}`
    tmp.close
    raise "Browser returned Response Code #{$browser.page.web_response.status_code}"
  end
end