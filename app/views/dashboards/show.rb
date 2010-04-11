class Dashboards::Show < Minimal::Template
  def content
    h2 t(:'dashboard.master_data')
    render :partial => 'master_data'

    h1 t(:'dashboard.overview'), :style => 'clear: both;'
    render :partial => 'activities/list', :locals => { :activities => current_activities }
    render :partial => 'activities/list', :locals => { :activities => aggregated_activities }

    render :partial => 'sidebar'
  end
end
