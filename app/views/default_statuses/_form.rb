module DefaultStatuses
  class Form < Minimal::Template
    def to_html
      h3(t(:new_default_status))
      form_for(object) do |f|
        hidden_field_tag('_method')

        fieldset do
          div { field_with_label(f, :collection_select, :employee_id, employees, :id, :full_name, :include_blank => true) }
          div { field_with_label(f, :collection_select, :day_of_week, day_names, :last, :first) }
          div { field_with_label(f, :time_select, :start_time, :minute_step => 5) }
          div { field_with_label(f, :time_select, :end_time, :minute_step => 5) }

          ul do
            Status::VALID_STATUSES.each do |status|
              li do
                text = t(:"statuses.#{status.underscore}", :scope => [:activerecord, :attributes, :status], :default => status)
                f.radio_button(:status, status)
                f.label("status_#{status.underscore}", text, :class => 'inline')
              end
            end
          end

          f.submit(t(:save))
        end
      end
    end

    protected

      def field_with_label(form, type, field, *args)
        form.label(field)
        form.send(type, field, *args)
      end

      def object
        @object ||= Status.new
      end
  end
end
