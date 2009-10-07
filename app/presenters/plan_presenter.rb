class PlanPresenter < Presenter
  def attributes
    { 
      :id => 'plan',
      :'data-start' => start_time_in_minutes,
      :'data-duration' => duration
    }
  end
  
  def render
    div(attributes) do
      days.map { |day| ShiftGroupPresenter.new(day, view).render(Array(shifts.by_day[day])) }
    end
  end
end
