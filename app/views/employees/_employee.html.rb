module Employees
  class Employee
    class Html < Minimal::Template
      def content
        li_for(employee, :class => "#{employee.state} resource", :'data-form-values' => employee.form_values_json) do
          image_tag(employee.gravatar_url(:size => 60))
          div(:class => 'actions') { link_to_destroy(employee) }
          h2(employee.full_name, :class => 'name')
          p(employee.possible_workplaces.map(&:name).join(', '), :class => 'qualifications')
        end
      end
      
      def link_to_destroy(employee)
        link_to(t(:destroy), employee_path(employee), :class => 'delete', :method => :delete, :confirm => t(:employee_delete_confirmation))
      end
    end
  end
end