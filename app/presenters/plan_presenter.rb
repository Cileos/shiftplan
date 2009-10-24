class PlanPresenter < Presenter
  def attributes
    {
      :id => dom_id(plan),
      :class => 'plan',
      :'data-start' => start_time_in_minutes,
      :'data-duration' => duration
    }
  end

  def render
    div(attributes) do
      h1(plan.name + span(plan_dates(plan), :class => 'dates')) +
      days.map { |day| ShiftGroupPresenter.new(day, view).render(Array(shifts.by_day[day])) }.join
    end
  end
end
