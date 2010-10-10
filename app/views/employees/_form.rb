module Employees
  class Form < Minimal::Template
    def to_html
      h3(t(:new_employee))

      form_for(object) do |f|
        hidden_field_tag('_method')

        fieldset do
          div { field_with_label(f, :text_field, :first_name) }
          div { field_with_label(f, :text_field, :last_name) }
          div { field_with_label(f, :date_select, :birthday, :start_year => Time.zone.now.year, :end_year => 1920, :include_blank => true) }
          div { field_with_label(f, :text_field, :tag_list) }
          div { field_with_label(f, :check_box, :active, {}, 1) }
        end

        h4(t(:qualifications, :scope => :'activerecord.attributes.employee'))
        fieldset do
          div do
            ul(:class => 'qualifications', :style => 'width:350px;') do
              current_account.qualifications.each do |qualification|
                li do
                  check_box_tag('employee[qualification_ids][]', qualification.id, object.has_qualification?(qualification), :id => "employee_qualification_#{qualification.id}", :class => 'employee_qualifications')
                  label_tag("employee_qualification_#{qualification.id}", qualification.name)
                end
              end
            end
          end
        end

        h4(t(:contact_information, :scope => :'activerecord.attributes.employee'))
        fieldset do
          div { field_with_label(f, :text_field, :email) }
          div { field_with_label(f, :text_field, :phone) }
          div { field_with_label(f, :text_field, :street) }
          div {
            field_with_label(f, :text_field, :zipcode, :class => 'zipcode')
            f.text_field(:city, :class => 'city')
          }
        end

        f.submit(t(:save))
      end
    end

    protected

      def field_with_label(form, type, field, *args)
        form.label(field)
        form.send(type, field, *args)
      end

      def object
        @object ||= ::Employee.new
      end
  end
end
