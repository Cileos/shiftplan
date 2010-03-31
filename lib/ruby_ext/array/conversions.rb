# http://www.brynary.com/2007/4/28/export-activerecords-to-csv
class Array
  def to_csv(options = {})
    if all? { |e| e.respond_to?(:to_row) }
      header_row = first.class.csv_fields.to_csv(options)
      content_rows = map { |e| e.to_row }.map { |row| row.to_csv(options) }
      ([header_row] + content_rows).join
    else
      FasterCSV.generate_line(self, options)
    end
  end
end
