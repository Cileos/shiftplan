class Plans::Form < Minimal::Template
  def content
    div :id => 'sidebar' do
      h3 t(:new_plan)
      form_for(Plan.new) do |f|
        hidden_field_tag '_method', ''

        fieldset do
          text_field f, :name
          text_field f, :start_date
          text_field f, :end_date
          div do
            label_tag :copy_from_id, t(:'activerecord.attributes.plan.template')
            select_tag 'copy_from[id]', tag(:option) + options_from_collection_for_select(templates, :id, :name)
          end
          div :id => 'copy_from_options' do
            copy_option :shifts
            copy_option :requirements
            copy_option :assignments
          end
          time_select f, :start_time
          time_select f, :end_time
        end

        h4 t(:options)
        fieldset do
          check_box f, :template
        end

        f.submit t(:save)
      end
    end
  end

  def text_field(builder, name)
    div do
      builder.label name
      builder.text_field name
    end
  end

  def check_box(builder, name)
    div do
      builder.label name, t(:"activerecord.attributes.plan.#{name}")
      builder.check_box name
    end
  end

  def copy_option(name)
    div do
      check_box_tag 'copy_from[elements][]', name, {}, :id => :"copy_from_#{name}"
      label_tag :"copy_from_#{name}", t(name), :class => 'inline'
    end
  end

  def time_select(builder, name)
    div do
      builder.label name
      builder.time_select name, :minute_step => 15
    end
  end
end
