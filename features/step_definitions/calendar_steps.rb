When /^I click on cell "([^"]*)"\/"([^"]*)"$/ do |column_label, row_label|
  column = column_index_for(column_label)
  row    = row_index_for(row_label)

  cell = page.find("tbody tr:nth-child(#{row+1}) td:nth-child(#{column+1})")
  cell.click
end

Then /^the cell "([^"]*)"\/"([^"]*)" should be active$/ do |column_label, row_label|
  column = column_index_for(column_label)
  row    = row_index_for(row_label)

  cell = page.find("tbody tr:nth-child(#{row+1}) td:nth-child(#{column+1})")
  cell[:class].should include('active')
end

def directions
  "up|down|right|left"
end

When /^I press arrow (#{directions})$/ do |direction|
  step %{I send arrow_#{direction} to "body"}
end

When /^I press arrow (#{directions}) (\d{1,2}) times$/ do |direction, times|
  times.to_i.times do
    step %{I send arrow_#{direction} to "body"}
  end
end

def column_index_for(column_label)
  columns = page.all('thead tr th').map(&:text)
  columns.should include(column_label)
  columns.index(column_label)
end

def row_index_for(row_label)
  rows = page.all('tbody th').map(&:text)
  rows.should include(row_label)
  rows.index(row_label)
end

