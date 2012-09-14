When /^I choose "([^"]*)" from the drop down "([^"]*)"$/ do |item, dropdown|
  #page.first('a.dropdown-toggle', :text => dropdown).click
  step %~I follow "#{item}"~
end
