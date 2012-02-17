module PlansHelper
  def months_for_select(plan, far=12)
    start = Date.today.beginning_of_month
    (0..far).to_a.map do |more|
      start + more.months
    end.map do |day|
      [l(day, :format => :long_without_day), day]
    end
  end

  def weeks_for_select(plan, far=55)
    start = Date.yesterday.beginning_of_week
    (0..far).to_a.map do |more|
      start + more.weeks
    end.map do |day|
      [l(day, :format => :week_with_first_day), day]
    end
  end

  def cwdays_for_select(plan, format=:week_day)
    start = Date.today.beginning_of_week
    (0..6).to_a.map do |more|
      day = start + more.days
      [l(day, :format => format), day.cwday]
    end

  end

  def durations_for_select(plan)
    Plan::Durations.map do |duration|
      [translate(duration, :scope => 'activerecord.values.plans.durations'), duration]
    end
  end
end
