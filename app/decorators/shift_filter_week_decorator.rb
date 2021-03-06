class ShiftFilterWeekDecorator < ShiftFilterDecorator

  def shifts_for(day, other)
    indexed(day, other).map(&:decorate).sort_by(&:deterministic_order)
  end

  # looks up the index, savely
  def indexed(day, other)
    index.fetch(day, other)
  end

  def index
    @index ||= ShiftIndexByNumericDay.new(y_attribute).with_records_added(records)
  end

  private

    def y_attribute
      :team
    end
end

