module Qualifications
  class Form < Minimal::Template
    def to_html
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

          f.submit(t(:save), :disable_with => t(:wait))
        end
      end
    end
  end
end