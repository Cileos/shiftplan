class Plans::Show::Day < Minimal::Template
  def content
    if shifts
      h2 l(day, :format => "%A, %d. %B %y")
      div :class => 'day', :'data-day' => day.strftime('%Y%m%d') do
        shifts.group_by(&:workplace).each do |workplace, shifts|
            render :partial => 'plans/show/workplace', :locals => { :workplace => workplace, :shifts => shifts }
        end
      end
    end
  end

  def attributes
    {
      :'data-start' => start_time_in_minutes,
      :'data-duration' => duration
    }
  end
end

