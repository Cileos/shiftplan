class Statuses::Statuses < Minimal::Template
  def content
    ul(:class => 'statuses') { render(:partial => 'status', :collection => statuses) }
  end
end
