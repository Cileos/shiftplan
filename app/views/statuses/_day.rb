class Statuses::Day < Minimal::Template
  def content
    h3(day.day)
    render(:partial => 'statuses', :locals => { :statuses => statuses })
    div(:class => 'status override resource', :'data-form-values' => Status.new(:employee_id => employee.id, :day => day).form_values_json) do
      div(:class => 'actions') do
        link_to(t(:new), new_status_path(:employee_id => employee.id, :day => day), :class => 'add', :id => 'new_status')
      end
    end
  end
end
