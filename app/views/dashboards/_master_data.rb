class Dashboards::MasterData < Minimal::Template
  def content
    ul(:id => 'master_data') do
      li do
        h3 t(:'navigation.employees')
        ul do
          li { link_to t(:'dashboard.manage_employees'), employees_path }
          li do
            link_to t(:'dashboard.import_employees'), import_employees_path
            template_link = capture { link_to t(:'dashboard.employees_import_template'), employees_path(:format => :csv, :blank => true) }
            span " (#{template_link})".html_safe
          end
          li { link_to t(:'dashboard.export_employees'), employees_path(:format => :csv) }
        end
      end
      li do
        h3 t(:'navigation.workplaces')
        ul do
          li { link_to t(:'dashboard.manage_workplaces'), workplaces_path }
        end
      end
      li do
        h3 t(:'navigation.qualifications')
        ul do
          li { link_to t(:'dashboard.manage_qualifications'), qualifications_path }
        end
      end
    end
  end
end
