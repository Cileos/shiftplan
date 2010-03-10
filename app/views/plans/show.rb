class Plans::Show < Minimal::Template
  def content
    div(attributes) do
      h1 do
        self << escape_once(plan.name).html_safe
        span plan_dates, :class => 'dates'
      end
      plan.days.each do |day|
        render :partial => 'plans/show/day', :locals => { :day => day, :shifts => Array(plan.shifts.by_day[day]) }
      end
    end

    render :partial => 'sidebar', :locals => { :employees => employees, :workplaces => workplaces, :qualifications => qualifications }
    render :partial => 'search'
  end

  def attributes
    {
      :id              => 'plan',
      :class           => "plan #{dom_id(plan)}", # yuck!
      :'data-start'    => plan.start_time_in_minutes,
      :'data-duration' => plan.duration
    }
  end

  def plan_dates
    t(:plan_from_to, :start_date => l(plan.start_date), :end_date => l(plan.end_date))
  end
end
