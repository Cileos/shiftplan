class Dashboards::Show < Minimal::Template
  def content
    h1 t(:'headings.overview')
    
    render :partial => 'activities/list', :locals => { :activities => current_activities }
    render :partial => 'activities/list', :locals => { :activities => aggregated_activities }
    
    div :id => 'sidebar' do
      h3 t(:'headings.statistics')
      ul do
        li { link_to t(:employees,      :count => number_of_employees), employees_path }
        li { link_to t(:qualifications, :count => number_of_qualifications), qualifications_path }
        li { link_to t(:workplaces,     :count => number_of_workplaces), workplaces_path }
      end
    end
  end
end
