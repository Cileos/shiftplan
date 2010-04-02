class Workplaces::Form < Minimal::Template
  def content
    h3(t(:new_workplace))

    form_for(object) do |f|
      hidden_field_tag('_method')

      fieldset do
        fieldset do
          div { field_with_label(f, :text_field, :name) }
          div { field_with_label(f, :text_field, :default_shift_length) }
          div { field_with_label(f, :check_box, :active, {}, 1) }
        end

        h4(t(:default_staffing, :scope => :'activerecord.attributes.workplace'))
        fieldset do
          div do
            f.label(:qualifications)
            ul(:id => 'required_qualifications', :class => 'qualifications') do
              current_account.qualifications.each do |qualification|
                li do
                  check_box_tag('workplace[qualification_ids][]', qualification.id, object.needs_qualification?(qualification),
                    :id => "workplace_qualification_#{qualification.id}",
                    :class => 'workplace_qualifications'
                  )
                  label_tag("workplace_qualification_#{qualification.id}", qualification.name)
                end
              end
            end
          end

          render(:partial => 'workplace_requirements_fields', :locals => { :workplace => object })
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
      @object ||= Workplace.new
    end
end
