class ShiftFilterWeekDecorator < ShiftFilterDecorator

  def shifts_for(day, other)
    indexed(day, other).sort_by(&:start_hour)
  end

  # looks up the index, savely
  def indexed(day, other)
    if at_day = index[day]
      if at_day.key?(other)
        at_day[other]
      else
        []
      end
    else
      []
    end
  end

  def index
    @index ||= index_records
  end

  private

    def index_records
      records.group_by(&:day).map do |day, concurrent|
        { day => concurrent.group_by(&y_attribute) }
      end.inject(&:merge) || {}
    end

    def y_attribute
      :team
    end
end

