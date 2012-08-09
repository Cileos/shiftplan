class OrganizationsController < InheritedResources::Base
  load_and_authorize_resource

  def create
    create! { dashboard_path }
  end

  protected

  def organization_param; params[:id] end

  def interpolation_options
    { organization: resource.name }
  end

  def build_resource
    @organization ||= current_user.owned_account.organizations.build( resource_params.first )
  end
end
