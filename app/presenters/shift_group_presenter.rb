class ShiftGroupPresenter < Presenter
  def attributes
    {
      :'data-start' => start_time_in_minutes,
      :'data-duration' => duration
    }
  end

  def render(shifts)
    div(:class => 'day', :'data-day' => object.strftime('%Y%m%d')) do
      h2(l(object, :format => "%A, %d. %B %y")) +
      ul(:class => 'shifts') do
        shifts.map { |shift| presenter_for(shift) }
      end
    end
  end
end
