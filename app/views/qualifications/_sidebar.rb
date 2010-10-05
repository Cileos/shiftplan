class Qualifications::Sidebar < Minimal::Template
  def to_html
    div(:id => 'sidebar') { render(:partial => 'form') }
  end
end
