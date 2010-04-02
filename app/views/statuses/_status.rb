class Statuses::Status < Minimal::Template
  def content
    content_tag_for(:li, status, :class => "#{status.status.to_s.underscore} override resource", :'data-form-values' => status.form_values_json) do
      text = t(:status_from_to, :from => l(status.start_time, :format => :time), :to => l(status.end_time, :format => :time))
      link_to(text, edit_status_path(status), :class => 'edit')
    end
  end
end
