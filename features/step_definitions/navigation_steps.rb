When /^I choose "([^"]*)" from the drop down "([^"]*)"$/ do |item, dropdown|
  #page.first('a.dropdown-toggle', :text => dropdown).click
  step %~I follow "#{item}"~
end

When /^I open (?:the )?#{capture_quoted} menu$/ do |menu|
  page.execute_script <<-EOJS
    $('header li:contains("#{menu}")').addClass('open')
  EOJS
end
