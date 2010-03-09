module StatusesHelper
  def employee_default_availabilities_dom_id(employee)
    "#{dom_id(employee)}_default_availabilities"
  end

  def statuses_for(day, statuses)
    statuses.select { |status| status.day == day }
  end

  def status_month_list_for(employee, number_of_months = 6)
    current_month_number = Date.current.month
    last_month_number    = current_month_number + number_of_months

    content_tag(:tr) do
      content_tag(:th, employee.full_name, :scope => 'row') +
      content_tag(:td) do
        link_to t(:defaults, :scope => :statuses),
                default_statuses_path(:anchor => employee_default_availabilities_dom_id(employee))
      end +
      (current_month_number..last_month_number).to_a.map do |month_number|
        year  = month_number > 12 ? Date.current.year + month_number/12 : Date.current.year
        month = month_number > 12 ? month_number % 12 : month_number

        content_tag(:td) do
          link_to l(Date.civil(year, month), :format => :month_and_year),
                  employee_statuses_path(employee, :year => year, :month => month)
        end
      end.join_safe
    end
  end
end
