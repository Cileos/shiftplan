class CopyWeekDecorator < ApplicationDecorator

  def previous_weeks_for_select(num=5)
    filters_for_previous_weeks(num).map do |filter|
      [filter.formatted_range_extended, "#{filter.year}/#{filter.week}"]
    end
  end

  private

  def filters_for_previous_weeks(num)
    return [] unless target_week && target_year
    span = plan.schedulings.filter week: target_week, year: target_year
    (1..num).to_a.collect do |back|
      prev = span.previous_week
      span = prev.dup
      prev.decorate(options)
    end
  end

end
