class SchedulingFilterWeekDecorator < SchedulingFilterDecorator
  def formatted_range
    I18n.localize monday, format: :week_with_first_day
  end

end

