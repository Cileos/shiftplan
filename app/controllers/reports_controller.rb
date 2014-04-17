class ReportsController < BaseController
  actions :new
  respond_to :csv, :html

  def new
    @output_encoding = 'UTF-8'
    new! do |respond|
      respond.csv { @csv_options = { force_quotes: true, col_sep: ';' } }
    end
  end

    private

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

