module Presenter
  class Plan
    class Workplace < Base
      def attributes
        {
          :'data-start' => start_time_in_minutes,
          :'data-duration' => duration
        }
      end

      def render(shifts)
        ul(:class => "workplace #{dom_id(workplace)} shifts") do
          shifts.map { |shift| presenter_for(shift, 'plan/shift') }
        end
      end
    end
  end
end
