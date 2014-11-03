class SchedulingFilterWeekDecorator < SchedulingFilterDecorator
  def formatted_range
    I18n.localize monday, format: :week_with_year
  end

  def formatted_range_extended
    I18n.localize monday, format: :week_with_first_day
  end

  def formatted_days
    days.map do |day|
      [
        I18n.localize(day, format: :week_day),      # day
        I18n.localize(day, format: :yearless_date), # date
        I18n.localize(day, format: :abbr_week_day), # abbr
        { class: day.today? && 'today' },
      ]
    end
  end

  def schedulings_for(day, other)
    scheduling_index.fetch(day.to_date, other).map(&:decorate).sort_by(&:deterministic_order).each do |s|
      s.focus_day = day
    end
  end

  def unavailabilities_for(day, other)
    unavailabilities_index.fetch(day.to_date.iso8601, other).sort_by(&:start_hour)
  end

  def previous_step
    monday.prev_week
  end

  def next_step
    monday.next_week
  end

  def today_path
    path_to_week(Time.current)
  end

  def path_to_date(date)
    path_to_week(date)
  end

  # Returns a Hash of Hashes of Arrays
  #
  #   scheduling.day(iso8601) => scheduling.xxxxxx => []
  #
  def scheduling_index
    @scheduling_index ||= SchedulingIndexByWeekDay.new(y_attribute).with_records_added(records)
  end

  def unavailabilities_index
    @unavailabilities_index ||= TwoDimensionalRecordIndex.new(:iso8601, y_attribute).with_records_added(unavailabilities)
  end

  private

    def y_attribute
      raise NotImplementedError, "must define #{self}#y_attribute to return attribute for y axis (ie. :employee)"
      :employee
    end

end

