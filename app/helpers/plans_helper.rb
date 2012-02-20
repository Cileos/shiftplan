module PlansHelper
  # needs monday (Date)
  def cwdays_for_select(monday, format=:week_day)
    (0..6).to_a.map do |more|
      day = monday + more.days
      [l(day, :format => format), day.iso8601]
    end

  end

  def durations_for_select(plan)
    Plan::Durations.map do |duration|
      [translate(duration, :scope => 'activerecord.values.plans.durations'), duration]
    end
  end
end
