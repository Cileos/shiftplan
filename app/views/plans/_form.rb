module Plans
  class Form < Minimal::Template
    def to_html
      div :id => 'sidebar' do
        h3 t(:new_plan)
        form_for(plan) do |f|
          hidden_field_tag '_method', ''

          fieldset do
            text_field f, :name
            select(f, :date, :start)
            select(f, :date, :end)
            div do
              label_tag :copy_from_id, t(:'activerecord.attributes.plan.template')
              select_tag 'copy_from[id]', capture { tag(:option) + options_from_collection_for_select(@templates, :id, :name) }
            end
            div :id => 'copy_from_options' do
              copy_option :shifts
              copy_option :requirements
              copy_option :assignments
            end
            select(f, :time, :start)
            select(f, :time, :end)
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
  
    def select(builder, type, name)
      div do
        id      = :"plan_#{name}"
        options = type == :date ? {} : { :ignore_date => true }
        builder.label(name, I18n.t(:"activerecord.attributes.plan.#{name}_#{type}"), :id => id)
        builder.send(:"#{type}_select", name, options.merge(:id => id))
      end
    end
  end
end