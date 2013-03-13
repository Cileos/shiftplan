class ShiftFilterWeekDecorator < ShiftFilterDecorator

  def shifts_for(day, other)
    indexed(day, other).sort_by(&:start_hour)
  end

  # looks up the index, savely
  def indexed(day, other)
    index.fetch(day, other)
  end

  def index
    @index ||= TwoDimensionalRecordIndex.new(:day, y_attribute).with_records_added(records)
  end

  private

    def y_attribute
      :team
    end
end

