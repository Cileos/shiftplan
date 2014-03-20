class ReportsController < BaseController
  actions :new

  def total_duration
    @report.records.reject(&:previous_day).sum { |s| s.decimal_duration }
  end
  helper_method :total_duration

    private

  def build_resource
    @report ||= Report.new(base_attrs.merge(resource_params.first))
  end

  def base_attrs
    { account: current_account, organization: organization }
  end

  def organization
    if org_id = resource_params.first[:organization_id]
      current_account.organizations.find_by_id(org_id)
    else
      current_organization
    end
  end
end

