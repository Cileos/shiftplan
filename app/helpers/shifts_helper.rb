module ShiftsHelper
  def monday
    Date.today.beginning_of_week
  end

  def days_for_select
    (0..6).to_a.map do |day|
      [ l(monday + day.days, format: :week_day), day ]
    end
  end
end
