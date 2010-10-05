class Workplaces::Index < Minimal::Template
  def to_html
    ul(:id => 'list', :class => 'workplaces') do
      li(:id => 'new_workplace', :class => 'workplace resource', :'data-form-values' => Workplace.new.form_values_json) do
        div('', :class => 'color', :style => 'background-color:transparent;')
        h2(t(:new))
        p(t(:add_workplace), :class => 'qualifications')
        div('', :class => 'actions')
      end
      render(:partial => 'workplace', :collection => workplaces)
    end

    render(:partial => 'sidebar')
  end
end
