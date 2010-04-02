class DefaultStatuses::DefaultStatus < Minimal::Template
  def content
    content_tag_for(:li, default_status, :class => "#{default_status.status.to_s.underscore} default resource", :'data-form-values' => default_status.form_values_json) do
      text = t(:status_from_to, :from => l(default_status.start_time, :format => :time), :to => l(default_status.end_time, :format => :time))
      link_to(text, default_status_url, :class => 'edit')
    end
  end

  protected

    def default_status_url
      default_status.new_record? ?
        new_default_status_path(:status => default_status.attributes.slice('start_time', 'end_time', 'status', 'day_of_week', 'employee_id')) :
        edit_default_status_path(employee, default_status)
    end
end
