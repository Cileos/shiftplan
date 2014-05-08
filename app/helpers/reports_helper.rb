module ReportsHelper
  def csv_export_params
    { format: :csv, report: report_params }
  end

  def xls_export_params
    { format: :xls, report: report_params }
  end

  def report_params
    (params[:report] || {}).merge(limit: 'all')
  end
end
