module ReportsHelper
  def csv_export_params
    params.merge(:format => :csv).merge(params[:report]).deep_merge(report: { limit: 'all' })
  end
end

# http://localhost:3000/accounts/mittelerde/organizations/orks/reports/new.csv?report%5Bemployee_ids%5D%5B%5D=&report%5Bfrom%5D=2014-04-01&report%5Bplan_ids%5D%5B%5D=&report%5Bplan_ids%5D%5B%5D=3&report%5Bteam_ids%5D%5B%5D=&report%5Bto%5D=2014-04-30&utf8=%E2%9C%93
