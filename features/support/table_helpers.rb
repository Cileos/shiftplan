# TODO move this to selectors.rb
def column_index_for(column_label)
  columns = page.all('thead tr th').map(&:text)
  columns.should include(column_label)
  columns.index(column_label)
end

def row_index_for(row_label)
  rows = page.all("tbody th").map(&:text)
  rows.should include(row_label)
  rows.index(row_label)
end