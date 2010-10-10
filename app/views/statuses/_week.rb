module Statuses
  class Week < Minimal::Template
    def to_html
      table(:class => 'calendar week') do
        tbody do
          @employees.each do |employee|
            tr do
              th(:scope => 'row', :class => "employee #{dom_id(employee)}") { initials_for(employee) }
              @days.each do |day|
                content_tag(:td, :id => "#{dom_id(employee)}_#{day.to_s(:number)}") do
                  render(:partial => 'day', :locals => { :day => day, :employee => employee, :statuses => statuses_for(day, employee.statuses.override.all) })
                end
              end
            end
          end
        end

        thead do
          tr(:class => 'weeks') do
            th('')
            th(:class => 'previous') { link_to_previous_week(year, week) }
            th(:colspan => 5, :class => 'current') { current_week(year, week) }
            th(:class => 'next') { link_to_next_week(year, week) }
          end
          tr(:class => 'days') do
            th('')
            @days.each { |day| th(l(day, :format => :short_with_day_name)) }
          end
        end
      end
    end
  end
end