class Plans::Sidebar < Minimal::Template
  def content
    div :id => 'sidebar' do
      h4 do
        self << t(:'navigation.employees')
        link_to_search('employee')
      end
      ul :id => 'employees' do
        render :partial => 'plans/sidebar/employee', :collection => employees
      end

      h4 do
        self << t(:'navigation.workplaces')
        link_to_search('employee')
      end
      ul :id => 'workplaces' do
        render :partial => 'plans/sidebar/workplace', :collection => workplaces
      end

      h4 do
        self << t(:'navigation.qualifications')
        link_to_search('qualification')
      end
      ul :id => 'qualifications' do
        render :partial => 'plans/sidebar/qualification', :collection => qualifications
      end
    end
  end

  def link_to_search(kind)
    link_to t(:search), '#', :id => "show_#{kind}_search", :class => 'show_search'
  end
end
