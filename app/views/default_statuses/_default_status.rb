class DefaultStatuses::DefaultStatus < Minimal::Template
  def to_html
    content_tag_for(:li, default_status, :class => "#{default_status.status.to_s.underscore} default resource", :'data-form-values' => default_status.form_values_json) do
      text = t(:status_from_to, :from => l(default_status.start_time, :format => :time), :to => l(default_status.end_time, :format => :time))
      link_to(text, default_status_url, :class => 'edit')
      span(:class => 'actions') { link_to_destroy(default_status) } unless default_status.new_record?
    end
  end

  protected

    def link_to_destroy(default_status)
      link_to(t(:destroy), status_path(default_status), :class => 'delete', :method => :delete, :confirm => t(:default_status_delete_confirmation))
    end

    def default_status_url
      default_status.new_record? ?
        new_default_status_path(:status => default_status.attributes.slice('start_time', 'end_time', 'status', 'day_of_week', 'employee_id')) :
        edit_default_status_path(employee, default_status)
    end
end
