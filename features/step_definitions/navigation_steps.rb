When /^I choose "([^"]*)" from the drop down "([^"]*)"$/ do |item, dropdown|
  step %~I open the "#{dropdown}" menu~
  step %~I follow "#{item}"~
end

When /^I open (?:the )?#{capture_quoted} menu$/ do |menu|
  page.execute_script <<-EOJS
    $('header li:contains("#{menu}")').addClass('open')
  EOJS
end
