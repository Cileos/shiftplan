module CsvTestHelper
  def csv_lib
    @csv_lib ||= begin
                   require 'csv'
                   CSV
                 end
  end

  def parse_csv(csv, delimiter)
    csv_lib.parse(csv, :col_sep => delimiter)
  rescue Exception => e
    STDERR.puts 'bad csv'
    STDERR.puts '-' * 72
    STDERR.puts csv
    STDERR.puts '-' * 72
    raise e
  end
end

if defined?(World) || respond_to?(:World)
  World(CsvTestHelper)
end

