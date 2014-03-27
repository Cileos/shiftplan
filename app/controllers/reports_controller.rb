class ReportsController < BaseController
  actions :new

  def total_duration
    @report.records.sum { |s| s.decimal_duration }
  end
  helper_method :total_duration

    private

  def build_resource
    @report ||= Report.new(base_attrs.merge(resource_params.first))
  end

  def base_attrs
    { account: current_account, organization: current_organization }
  end
end

