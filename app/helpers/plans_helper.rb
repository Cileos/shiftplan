module PlansHelper
  # needs monday (Date)
  def cwdays_for_select(monday=nil, format=:week_day)
    monday = Date.new(2012,1,2) unless monday
    monday = monday.beginning_of_week unless monday.cwday == 1
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
