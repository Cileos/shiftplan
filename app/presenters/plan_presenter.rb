class PlanPresenter < Presenter
  def attributes
    {
      :id => 'plan',
      :class => "plan #{dom_id(plan)}", # yuck!
      :'data-start' => start_time_in_minutes,
      :'data-duration' => duration
    }
  end

  def render
    div(attributes) do
      h1(plan.name + span(plan_dates(plan), :class => 'dates')) +
      days.map { |day| presenter_for(day, 'plan/day').render(Array(shifts.by_day[day])) }.join.html_safe
    end
  end
end
