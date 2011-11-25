When /^I click on cell "([^"]*)"\/"([^"]*)"$/ do |column_label, row_label|
  columns = page.all('thead tr th').map(&:text)
  rows    = page.all('tbody tr td:first').map(&:text)

  columns.should include(column_label)
  rows.should include(row_label)

  column = columns.index(column_label)
  row    = rows.index(row_label)

  cell = page.find("tbody tr:nth-child(#{row+1}) td:nth-child(#{column})")
  cell.click
end
