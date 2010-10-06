module Statuses
  class Index < Minimal::Template
    def to_html
      if employee_given?
        render(:partial => 'employee', :locals => { :employee => @employee })
      else
        if week_given?
          h1(t(:statuses, :scope => :navigation))
          render(:partial => 'week', :locals => { :year => @year, :week => @week, :employees => @employees })
          render(:partial => 'sidebar')
        else
          h1(t(:statuses, :scope => :navigation))

          link_to(t(:click_here_to_manage_availabilities_by_week), employees_week_statuses_path(:year => Date.current.year, :week => Date.current.cweek))

          table do
            tbody do
              @employees.each { |employee| status_month_list_for(employee) }
            end
          end
        end
      end
    end

    protected

      def employee_given?
        @employee || respond_to?(:employee) || view.instance_variable_defined?(:@employee)
      end

      def week_given?
        @week || respond_to?(:week) || view.instance_variable_defined?(:@week)
      end
  end
end