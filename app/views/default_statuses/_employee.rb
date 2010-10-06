module DefaultStatuses
  class Employee < Minimal::Template
    def to_html
      tr do
        th(:scope => 'row') { a(employee.full_name, :name => employee_default_availabilities_dom_id(employee)) }
        td { link_to(t(:override_defaults), employee_statuses_path(employee)) }
        numeric_days_of_week.each do |day_of_week|
          locals = { :employee => employee, :day_of_week => day_of_week, :statuses => Status.fill_gaps!(@employee, day_of_week, default_statuses[day_of_week]) }
          render(:partial => 'day', :locals => locals)
        end
      end
    end

    protected

      def default_statuses
        @default_statuses ||= employee.statuses.default.group_by(&:day_of_week)
      end
  end
end
