module Employees
  class Index < Minimal::Template
    def to_html
      ul(:id => 'list', :class => 'employees') do
        li(:id => 'new_employee', :class => 'employee resource', :'data-form-values' => Employee.new.form_values_json) do
          image_tag(Employee.new.gravatar_url(:size => 60))
          h2(t(:new))
          p(t(:add_employee), :class => 'qualifications')
          div(:class => 'actions') {}
        end

        render(:partial => 'employee', :collection => @employees)
      end

      render(:partial => 'sidebar')
    end
  end
end
