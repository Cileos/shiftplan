When /^I choose "([^"]*)" from the drop down "([^"]*)"$/ do |item, dropdown|
  with_scope 'the navigation' do
    page.first('li.dropdown a.dropdown-toggle', :text => dropdown).click
  end
  step %~I follow "#{item}"~
end
