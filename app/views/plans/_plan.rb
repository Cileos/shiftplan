class Plans::Plan < Minimal::Template
  def content
    tr_for(plan, :class => resource_css_classes(plan), :'data-form-values' => plan.form_values_json) do
      td :class => :name do
        link_to(plan.name, plan_path(plan))
      end
      td :class => :start_date do
        self << l(plan.start_date)
      end
      td :class => :end_date do
        self << l(plan.end_date)
      end
      td :class => :shifts do
        self << l(plan.start_time, :format => '%H:%M') + ' - '
        self << l(plan.end_time, :format => '%H:%M' )
      end
      td :class => :actions do
        link_to('edit', edit_plan_path(plan), :class => 'edit')
        link_to(t(:destroy), plan_path(plan), :class => 'delete', :method => :delete, :confirm => t(:plan_delete_confirmation))
      end
    end
  end
end
