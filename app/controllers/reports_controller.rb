class ReportsController < BaseController
  actions :new
  respond_to :csv, :html

  def new
    new! do |respond|
      respond.csv do
        @csv_options = { force_quotes: true, col_sep: ';' }
        @output_encoding = 'UTF-8'
        @filename = "#{filename}.csv"
      end
      respond.xls do
        headers['Content-Disposition'] = "attachment; filename=\"#{filename}.xls\""
      end
    end
  end

    private

  def filename
    "#{current_account.name}-report"
  end

  def build_resource
    @report ||= Report.new(base_attrs.reverse_merge(resource_params.first))
  end

  def base_attrs
    { account: current_account, organization_ids: organization_ids }
  end

  def organization_ids
    if current_organization
      [current_organization.id.to_s]
    else
      resource_params.first[:organization_ids] || []
    end
  end
end

