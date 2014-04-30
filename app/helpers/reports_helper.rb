module ReportsHelper
  def csv_export_params
    { format: :csv, report: params_report }
  end

  def xls_export_params
    { format: :xls, report: params_report }
  end

  def params_report
    (params[:report] || {}).merge(limit: 'all')
  end
end
