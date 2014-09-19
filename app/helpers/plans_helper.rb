module PlansHelper
  # needs monday (Date)
  def cwdays_for_select(scheduling, format=:week_day)
    monday = scheduling.date || Date.new(2012,1,2)
    monday = monday.beginning_of_week unless monday.cwday == 1
    (0..6).
      to_a.
      map    { |more| monday + more.days }.
      select { |day| scheduling.plan.period.include_date?(day) }.
      map    { |day| [l(day, :format => format), day.iso8601] }
  end

  def employees_for_select(scheduling)
    org = scheduling.plan.organization
    org.employees.select do |e|
      e.organization_id = org.id
      e.planable?
    end
  end

  def destroy_link_for_plan(plan, html_options={})
    html_options = {
      class: 'button button-warning button-small',
      title: ta(:destroy)
    }
    if !plan.schedulings.present?
      html_options[:method]  = :delete
      html_options[:confirm] = ta(:confirm_destroy_plan, plan: plan.name)
      link_to ta(:destroy), nested_resources_for(plan), html_options
    else
      # TODO make this unobstrusive
      link_to ta(:destroy), '#', html_options.merge(
        onclick: "alert('#{ta(:plan_cannot_be_destroyed, plan: plan.name, entries: plan.schedulings.count)}')"
      )
    end
  end
end
