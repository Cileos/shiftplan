module Statuses
  class Sidebar < Minimal::Template
    def to_html
      div(:id => 'sidebar') { render(:partial => 'form', :locals => { :employee => @employee }) }
    end
  end
end