class Statuses::DefaultStatuses < Minimal::Template
  def content
    default_statuses = employee.statuses.default.group_by(&:day_of_week)

    table(:class => "#{dom_id(employee)}_defaults defaults") do
      tbody do
        tr do
          0.upto(6) do |day_of_week|
            locals = { :employee => employee, :day_of_week => day_of_week, :statuses => Status.fill_gaps!(employee, day_of_week, default_statuses[day_of_week]) }
            render(:partial => 'default_statuses/day', :locals => locals)
          end
        end
      end

      thead do
        tr do
          days_of_week.each { |day_of_week| th(t(:'date.day_names')[day_of_week]) }
        end
      end
    end
  end
end
