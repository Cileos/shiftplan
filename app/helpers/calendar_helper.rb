module CalendarHelper
  def calendar_options(employee)
    {
      :current_month  => lambda { |date| l(date, :format => '%B %Y') },
      :next_month     => lambda { |date| link_to(l(date, :format => '%B %Y &raquo;').html_safe, employee_statuses_path(employee, :year => date.year, :month => date.month)) },
      :previous_month => lambda { |date| link_to(l(date, :format => '&laquo; %B %Y').html_safe, employee_statuses_path(employee, :year => date.year, :month => date.month)) }
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
