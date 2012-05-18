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

  def show_with_abbr(content_full, content_abbr, clss=nil, opts={})
    ret = content_tag :span, content_full, class: clss
    ret += content_tag :abbr, content_abbr, {class: clss, title: content_full}
    ret
  end
end
