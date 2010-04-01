class Dashboards::Show < Minimal::Template
  def content
    h1 t(:'dashboard.overview')
    render :partial => 'activities/list', :locals => { :activities => current_activities }
    render :partial => 'activities/list', :locals => { :activities => aggregated_activities }

    h2 t(:'dashboard.master_data')
    render :partial => 'master_data'

    render :partial => 'sidebar'
  end
end
