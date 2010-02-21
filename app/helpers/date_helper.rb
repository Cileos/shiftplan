module DateHelper
  def days_of_week
    days_of_week = (0..6).to_a
    first_day_of_week = I18n.t(:'date.first_day_of_week', :default => 0)
    first_day_of_week.times { days_of_week.push(days_of_week.shift) }
    days_of_week
  end
end
