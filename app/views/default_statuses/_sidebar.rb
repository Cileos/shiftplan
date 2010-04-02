class DefaultStatuses::Sidebar < Minimal::Template
  def content
    div(:id => 'sidebar') { render(:partial => 'form') }
  end
end
