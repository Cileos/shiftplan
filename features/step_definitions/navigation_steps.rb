When /^I choose "([^"]*)" from the drop down "([^"]*)"$/ do |item, dropdown|
  step %~I open the "#{dropdown}" menu~
  step %~I follow "#{item}"~
end

When /^I choose "([^"]*)" from the session and settings menu item/ do |item|
  begin
    page.execute_script <<-EOJS
      $('#session-and-settings').addClass('open')
    EOJS
  rescue Capybara::NotSupportedByDriverError => e
    # in rack server, menu opens you
  end
  step %~I follow "#{item}"~
end

When /^I open the notification hub menu$/ do
  begin
    page.execute_script <<-EOJS
      $("a#notifications-count").click()
    EOJS
  rescue Capybara::NotSupportedByDriverError => e
    # in rack server, menu opens you
  end
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
