# adapted from http://www.brynary.com/2007/4/28/export-activerecords-to-csv
class ActiveRecord::Base
  class << self
    def to_csv(*args)
      all.to_csv(*args)
    end

    def csv_fields
      content_columns.map(&:name) - %w(created_at updated_at)
    end
  end
  
  def to_row
    self.class.csv_fields.map { |c| self.send(c) }
  end
end
