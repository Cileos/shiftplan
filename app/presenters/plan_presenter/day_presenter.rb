class PlanPresenter
  class DayPresenter < Presenter
    def attributes
      {
        :'data-start' => start_time_in_minutes,
        :'data-duration' => duration
      }
    end

    def render(shifts)
      h2(l(object, :format => "%A, %d. %B %y")) +
      div(:class => 'day', :'data-day' => object.strftime('%Y%m%d')) do
        shifts.group_by(&:workplace).map do |workplace, shifts|
          presenter_for(workplace, 'plan/workplace').render(shifts)
        end.join("\n")
      end
    end
  end
end
