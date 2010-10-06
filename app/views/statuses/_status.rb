module Statuses
  class Status < Minimal::Template
    def to_html
      content_tag_for(:li, status, :class => "#{status.status.to_s.underscore} override resource", :'data-form-values' => status.form_values_json) do
        text = t(:status_from_to, :from => l(status.start_time, :format => :time), :to => l(status.end_time, :format => :time))
        link_to(text, edit_status_path(status), :class => 'edit')
        span(:class => 'actions') { link_to_destroy(status) }
      end
    end

    protected

      def link_to_destroy(status)
        link_to(t(:destroy), status_path(status), :class => 'delete', :method => :delete, :confirm => t(:status_delete_confirmation))
      end
  end
end