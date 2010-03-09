module CalendarHelper
  def calendar_options(employee)
    {
      :calendar_class     => "#{dom_id(employee)}_overrides calendar",
      :use_full_day_names => true,
      :current_month      => lambda { |date| l(date, :format => :month_and_year) },
      :next_month         => lambda { |date| link_to((l(date, :format => :month_and_year) + '&raquo;').html_safe, employee_statuses_path(employee, :year => date.year, :month => date.month)) },
      :previous_month     => lambda { |date| link_to(('&laquo;' + l(date, :format => :month_and_year)).html_safe, employee_statuses_path(employee, :year => date.year, :month => date.month)) }
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
