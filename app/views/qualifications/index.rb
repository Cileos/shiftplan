class Qualifications::Index < Minimal::Template
  def content
    ul(:id => 'list', :class => 'qualifications') do
      li(:id => 'new_qualification', :class => 'qualification resource', :'data-form-values' => Qualification.new.form_values_json) do
        div('', :class => 'color', :style => 'background-color:transparent;')
        h2(t(:new))
        p(t(:add_qualification), :class => 'qualifications')
        div('', :class => 'actions')
      end
      render(:partial => 'qualification', :collection => qualifications)
    end

    render(:partial => 'sidebar')
  end
end
