class SchedulingFilterWeekDecorator < SchedulingFilterDecorator
  def formatted_range
    I18n.localize monday, format: :week_with_first_day
  end

  def formatted_days
    days.map do |day|
      [
        I18n.localize(day, format: :week_day_with_yearless_date), # full
        I18n.localize(day, format: :abbr_week_day)                # abbr
      ]
    end
  end

  def schedulings_for(day, other)
    indexed(day, other).sort_by(&:start_hour)
  end

  # looks up the index, savely
  def indexed(day, other)
    if at_day = index[day.iso8601]
      if at_day.key?(other)
        at_day[other]
      else
        []
      end
    else
      []
    end
  end

  def previous_path
    path_to_week(monday.prev_week)
  end

  def next_path
    path_to_week(monday.next_week)
  end

  def today_path
    path_to_week(Date.today)
  end

  # Returns a Hash of Hashes of Arrays
  #
  #   scheduling.day(iso8601) => scheduling.xxxxxx => []
  #
  def index
    @index ||= index_records
  end

  private

    def index_records
      records.group_by(&:iso8601).map do |day, concurrent|
        { day => concurrent.group_by(&y_attribute) }
      end.inject(&:merge) || {}
    end

    def y_attribute
      raise NotImplementedError, "must define #{self}#y_attribute to return attribute for y axis (ie. :employee)"
      :employee
    end

end

