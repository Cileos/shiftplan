class PlanPresenter
  class WorkplacePresenter < Presenter
    def attributes
      {
        :'data-start' => start_time_in_minutes,
        :'data-duration' => duration
      }
    end

    def render(shifts)
      ul(:class => "workplace #{dom_id(workplace)} shifts") do
        shifts.map { |shift| presenter_for(shift, 'plan/shift').render }.join.html_safe
      end.html_safe
    end
  end
end
