module ReportsHelper
  def csv_export_params
    { format: :csv, report: (params[:report] || {}).merge(limit: 'all') }
  end
end
