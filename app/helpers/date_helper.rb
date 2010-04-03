module DateHelper
  def days_of_week
    @days_of_week ||= begin
      days_of_week = I18n.t(:'date.day_names').to_a.dup
      first_day_of_week = I18n.t(:'date.first_day_of_week', :default => 0)
      first_day_of_week.to_i.times { days_of_week.push(days_of_week.shift) }
      days_of_week
    end
  end
end
