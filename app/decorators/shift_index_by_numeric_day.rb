class ShiftIndexByNumericDay < TwoDimensionalRecordIndex
  def initialize(y)
    super(:day, y)
  end

  def reindex!
    i = Hash.new
    store.each do |record|
      day = record.day
      sec = record.public_send(y)

      store_in(i, day, sec, record)

      if record.is_overnight?
        store_in(i, day + 1, sec, record)
      end
    end

    @indexed = i
  end

private

  def store_in(indexed, day, sec, record)
    indexed[day]      ||= {}
    indexed[day][sec] ||= []
    indexed[day][sec] << record
  end
end
