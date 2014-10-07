class SchedulingIndexByWeekDay < TwoDimensionalRecordIndex
  def initialize(y)
    super(:week_day, y)
  end

  def reindex!
    i = Hash.new
    store.each do |record|
      date = record.date
      sec = record.public_send(y)

      store_in(i, date, sec, record)

      if record.is_overnight?
        store_in(i, date.tomorrow, sec, record)
      end
    end

    @indexed = i
  end

private

  def store_in(indexed, date, sec, record)
    key = date
    indexed[key]      ||= {}
    indexed[key][sec] ||= []
    indexed[key][sec] << record
  end
end
