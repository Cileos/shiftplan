module DateHelper
  def days_of_week
    @days_of_week ||= begin
      days_of_week = I18n.t(:'date.day_names').to_a.dup
      first_day_of_week.times { days_of_week.push(days_of_week.shift) }
      days_of_week
    end
  end

  def numeric_days_of_week
    @numeric_days_of_week ||= begin
      numeric_days_of_week = (0..6).to_a
      first_day_of_week.times { numeric_days_of_week.push(numeric_days_of_week.shift) }
      numeric_days_of_week
    end
  end

  def first_day_of_week
    @first_day_of_week ||= I18n.t(:'date.first_day_of_week', :default => 0).to_i
  end
end
