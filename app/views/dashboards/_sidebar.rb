class Dashboards::Sidebar < Minimal::Template
  def to_html
    div :id => 'sidebar' do
      h3 t(:'dashboard.statistics')
      ul do
        li { link_to t(:employees,      :count => number_of_employees), employees_path }
        li { link_to t(:qualifications, :count => number_of_qualifications), qualifications_path }
        li { link_to t(:workplaces,     :count => number_of_workplaces), workplaces_path }
      end
    end
  end
end
