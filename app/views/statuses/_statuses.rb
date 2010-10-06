module Statuses
  class Statuses::Statuses < Minimal::Template
    def to_html
      ul(:class => 'statuses') { render(:partial => 'status', :collection => statuses) }
    end
  end
end