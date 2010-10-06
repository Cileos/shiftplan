module DefaultStatuses
  class Index < Minimal::Template
    def to_html
      h1(t(:default_statuses, :scope => :navigation))

      table do
        tbody { render(:partial => 'employee', :collection => @employees) }
        thead do
          tr do
            th
            th
            days_of_week.each { |day_of_week| th(t(:'date.day_names')[day_of_week]) }
          end
        end
      end

      render(:partial => 'sidebar')
    end
  end
end
