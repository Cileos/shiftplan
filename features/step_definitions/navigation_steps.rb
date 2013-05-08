When /^I choose "([^"]*)" from the drop down "([^"]*)"$/ do |item, dropdown|
  step %~I open the "#{dropdown}" menu~
  step %~I follow "#{item}"~
end

When /^I choose "([^"]*)" from the user navigation$/ do |item|
  begin
    page.execute_script <<-EOJS
      $('.user-navigation .dropdown').addClass('open')
    EOJS
  rescue Capybara::NotSupportedByDriverError => e
    # in rack server, menu opens you
  end
  step %~I follow "#{item}"~
end

When /^I open (?:the )?#{capture_quoted} menu$/ do |menu|
  begin
    page.execute_script <<-EOJS
      $('li:contains("#{menu}")').addClass('open')
    EOJS
  rescue Capybara::NotSupportedByDriverError => e
    # in rack server, menu opens you
  end
end
