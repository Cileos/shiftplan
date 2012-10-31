module PlansHelper
  # needs monday (Date)
  def cwdays_for_select(monday=nil, format=:week_day)
    monday = Date.new(2012,1,2) unless monday
    monday = monday.beginning_of_week unless monday.cwday == 1
    (0..6).to_a.map do |more|
      day = monday + more.days
      [l(day, :format => format), day.iso8601]
    end.select { |day_option| !filter.outside_plan_period?(Date.parse(day_option.last)) }
  end

  def durations_for_select(plan)
    Plan::Durations.map do |duration|
      [translate(duration, :scope => 'activerecord.values.plans.durations'), duration]
    end
  end

  def destroy_link_for(plan, html_options={})
    html_options = {
      class: 'utility-button icon-button button-warning',
      title: ta(:destroy)
    }
    if !plan.schedulings.present?
      html_options[:method]  = :delete
      html_options[:confirm] = ta(:confirm_destroy_plan, plan: plan.name)
      link_to i(:destroy), nested_resources_for(plan), html_options
    else
      link_to_function i(:destroy),
        "alert('#{ta(:plan_cannot_be_destroyed, plan: plan.name, entries: plan.schedulings.count)}')",
        html_options
    end
  end
end
