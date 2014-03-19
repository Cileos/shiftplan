class ReportsController < BaseController
  actions :new

  def total_duration
    @report.records.reject(&:previous_day).sum { |s| s.decimal_duration }
  end
  helper_method :total_duration

    private

  def build_resource
    @report ||= Report.new(account_id: current_account.id, organization_id: organization.try(:id))
  end

  def organization
    org_id = resource_params.first[:organization_id]
    org_id && current_account.organizations.find_by_id(org_id) ||
      current_organization
  end
end

