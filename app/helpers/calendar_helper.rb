module CalendarHelper
  def link_to_previous_week(year, week)
    # TODO: maybe extract this to Date class?
    if week <= 1
      year -= 1
      week  = Date.weeks_in_year(year)
    else
      week -= 1
    end

    link_to "&laquo; #{t(:calendar_week, :week => week, :scope => :date)}".html_safe,
            employees_week_statuses_path(year, week)
  end

  def link_to_next_week(year, week)
    # TODO: maybe extract this to Date class?
    if week + 1 > Date.weeks_in_year(year)
      year += 1
      week  = 1
    else
      week += 1
    end

    link_to "#{t(:calendar_week, :week => week, :scope => :date)} &raquo;".html_safe,
            employees_week_statuses_path(year, week)
  end

  def current_week(year, week)
    days = Date.week(year, week)
    "#{t(:calendar_week, :week => week, :scope => :date)} (#{t(:'date.range', :start => days.first, :end => days.last)})"
  end

  def calendar_options(employee)
    {
      :calendar_class     => "#{dom_id(employee)}_overrides overrides calendar",
      :use_full_day_names => true,
      :current_month      => lambda { |date| l(date, :format => :month_and_year) },
      :next_month         => lambda { |date| link_to((l(date, :format => :month_and_year) + ' &raquo;').html_safe, employee_statuses_path(employee, :year => date.year, :month => date.month)) },
      :previous_month     => lambda { |date| link_to(('&laquo; ' + l(date, :format => :month_and_year)).html_safe, employee_statuses_path(employee, :year => date.year, :month => date.month)) }
    }
  end

  def calendar_status_proc(employee)
    lambda do |day|
      [
        render(:partial => 'day', :locals => {
          :day => day,
          :employee => employee,
          :statuses => statuses_for(day, employee.statuses.override.all)
          }),
        { :id => "#{dom_id(employee)}_#{day.to_s(:number)}" }
      ]
    end
  end
end
