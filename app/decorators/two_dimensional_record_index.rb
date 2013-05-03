# for performance reasons, we do not want to search through all the available schedulings for each cell, so we index them
class TwoDimensionalRecordIndex

  attr_reader :x, :y, :store
  def initialize(x,y)
    @x, @y = x, y
    @store = []
  end

  def <<(records)
    Array(records).each { |r| add_record r }
  end

  def with_records_added(records)
    self << records
    self
  end

  def [](key)
    indexed[key]
  end

  def keys
    indexed.keys
  end

  def indexed
    @indexed ||= reindex!
  end

  def reindex!
    @indexed = store.group_by(&x).map do |xval, records_with_xval|
      { xval => records_with_xval.group_by(&y) }
    end.inject(&:merge) || {}
  end

  def fetch(xv, yv)
    if at_x = indexed[xv]
      if at_x && at_x.key?(yv)
        at_x[yv]
      else
        []
      end
    else
      []
    end

  end

  private

  def add_record(record)
    @indexed = false
    store << record
  end
end
