class Qualifications::Form < Minimal::Template
  def content
    h3(t(:new_qualification))
    form_for(Qualification.new) do |f|
      hidden_field_tag('_method')

      fieldset do
        fieldset do
          div do
    	      f.label(:name)
    	      f.text_field(:name)
  	      end
        end

        f.submit(t(:save))
      end
    end
  end
end
