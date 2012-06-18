When /^I click on #{capture_cell}$/ do |cell|
  page.execute_script <<-EOJS
    $("#{selector_for(cell)}").click()
  EOJS
end

When /^I click on (?:the )?scheduling #{capture_quoted}$/ do |quickie|
  page.find("li", text: quickie).click()
end

Then /^the #{capture_cell} should be (focus)$/ do |cell, predicate|
  page.find(selector_for(cell))[:class].split.should include(predicate)
end

Then /^the scheduling #{capture_quoted} should be (focus)$/ do |quickie, predicate|
  page.find("li", text: quickie)[:class].split.should include(predicate)
end

def directions
  ['arrow up','arrow down','arrow right','arrow left','return','escape', 'tab', 'enter'].join('|')
end

When /^I press (#{directions})$/ do |direction|
  direction.gsub!(' ', '_')
  step %{I send #{direction} to "body"}
end

When /^I press (#{directions}) in the #{capture_quoted} field$/ do |key, field|
  key.gsub!(' ', '_')
  find_field(field).send_string_of_keys(key)
end

When /^I press key #{capture_quoted}$/ do |key|
  find('body').send_string_of_keys(key)
end

When /^I press (#{directions}) (\d{1,2}) times$/ do |direction, times|
  times.to_i.times do
    step %{I press #{direction}}
  end
end

When /^I schedule #{capture_quoted} on #{capture_quoted} for #{capture_quoted}$/ do |employee, day, quickie|
  steps <<-EOSTEPS
     When I click on cell "#{day}"/"#{employee}"
      And I wait for the modal box to appear
      And I wait for the new scheduling form to appear
      And I fill in "Quickie" with "#{quickie}"
      And I press "Anlegen"
      And I wait for the new scheduling form to disappear
      And I wait for the modal box to disappear
  EOSTEPS
end

Then /^I should see a calendar (?:titled|captioned) #{capture_quoted}$/ do |caption|
  step %Q~I should see "#{caption}" within ".caption" within the calendar navigation~
end

Then /^I should see the following calendar:$/ do |expected|
  calendar = find(selector_for('the calendar'))
  actual = calendar.all("thead:first tr, tbody tr").map do |tr|
    tr.all('th, td').map do |cell|
      extract_text_from_cell(cell) || ''
    end
  end
  expected.diff! actual
end

# TODO multiple entries per "cell"/column
Then /^I should see the following calendar with (?:hours in week):$/ do |expected|
  calendar = find(selector_for('the calendar'))
  actual = calendar.all("thead:first tr, tbody tr").map do |tr|
    tr.all('th, td').map do |cell|
      extract_text_from_cell(cell) || ''
    end
  end
  expected.diff! actual
end

Then /^I should see the following WAZ:$/ do |expected|
  calendar = find(selector_for('the calendar'))
  actual = calendar.all("tbody tr").map do |tr|
    tr.all('th:first span.name, th:first .wwt_diff .badge').map(&:text)
  end
  expected.diff! actual
end

Then /^the employee #{capture_quoted} should have a (yellow|green|red|grey) hours\/waz value of "(\d+ \/ \d+|\d+)"$/ do |employee_name, color, text|
  color_class_mapping = {
    'yellow' => 'badge-warning',
    'green'  => 'badge-success',
    'red'    => 'badge-important',
    'grey'    => nil
  }

  classes = [ 'badge', color_class_mapping[color]].compact
  with_scope 'the calendar' do
    row = row_index_for employee_name
    within "tbody tr:nth-child(#{row+1}) th" do
      badge = ".wwt_diff .#{classes.join('.')}"
      page.should have_css(badge)
      page.first(badge).text.should == text
    end
  end
end

