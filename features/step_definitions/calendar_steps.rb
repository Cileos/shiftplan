When /^I click on cell "([^"]+)"\/"([^"]+)"$/ do |column_label, row_label|
  column = column_index_for(column_label)
  row    = row_index_for(row_label)

  page.execute_script <<-EOJS
    $("tbody tr:nth-child(#{row+1}) td:nth-child(#{column+1})").click()
  EOJS
end

Then /^the cell "([^"]+)"\/"([^"]+)" should be (focus)$/ do |column_label, row_label, predicate|
  column = column_index_for(column_label)
  row    = row_index_for(row_label)

  cell = page.find("tbody tr:nth-child(#{row+1}) td:nth-child(#{column+1})")
  cell[:class].split.should include(predicate)
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
  step %Q~I should see "#{caption}" within "caption" within the calendar~
end

# FIXME can only match the whole calendar
Then /^I should see the following calendar:$/ do |expected|
  actual = find(selector_for('the calendar')).all("tr").map do |tr|
    tr.all('th, td').map(&:text).map {|text| text.strip.gsub(/\s+/, ' ') }
  end
  expected.diff! actual
end

Then /^#{capture_model} should have a (yellow|green|red|grey) hours\/waz value of "(\d+ von \d+|\d+)"$/ do |employee, color, text|
  employee = model!(employee)
  column = column_index_for("Stunden/WAZ")
  row    = row_index_for(employee.name)

  color_class_mapping = {
    'yellow' => 'label-warning',
    'green'  => 'label-success',
    'red'    => 'label-important',
    'grey'    => ''
  }

  cell = find("#{selector_for('the calendar')} tbody tr:nth-child(#{row+1}) td:nth-child(#{column+1}) span[class='label #{color_class_mapping[color]}']")
  assert_equal text, cell.text
end

