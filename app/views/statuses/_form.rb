module Statuses
  class Form < Minimal::Template
    def to_html
      h3(t(:new_status))
      form_for(object) do |f|
        hidden_field_tag('_method')

        fieldset do
          if employee_given?
            f.hidden_field(:employee_id)
          else
            field_with_label(f, :collection_select, :employee_id, current_account.employees, :id, :full_name, :include_blank => true)
          end

          div(:class => 'default_only', :style => 'display:none;') do
            field_with_label(f, :collection_select, :day_of_week, day_names, :last, :first, {}, :disabled => true)
          end

          div(:class => 'override_only') { field_with_label(f, :date_select, :day, :start_year => Time.zone.now.year) }

          div { field_with_label(f, :time_select, :start_time, :minute_step => 5) }
          div { field_with_label(f, :time_select, :end_time, :minute_step => 5) }

          ul do
            ::Status::VALID_STATUSES.each do |status|
              li do
                text = t(:"statuses.#{status.underscore}", :scope => [:activerecord, :attributes, :status], :default => status)
                f.radio_button(:status, status)
                f.label("status_#{status.underscore}", text, :class => 'inline')
              end
            end
          end

          f.submit(t(:save), :disable_with => t(:wait))
        end
      end
    end

    protected

      def field_with_label(form, type, field, *args)
        form.label(field)
        form.send(type, field, *args)
      end

      def employee_given?
        # is the last one really correct?
        @employee || (respond_to?(:employee) && employee) || view.instance_variable_defined?(:@employee)
      end

      def object
        @object ||= ::Status.new(:employee => employee_given? ? employee : nil)
      end
  end
end