class ReportsController < BaseController
  actions :new

    private

  def build_resource
    @report ||= Report.new(base_attrs.merge(resource_params.first))
  end

  def base_attrs
    { account: current_account, organization: current_organization }
  end
end

