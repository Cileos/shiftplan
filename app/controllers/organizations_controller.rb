class OrganizationsController < InheritedResources::Base
  load_and_authorize_resource

  protected

  def organization_param; params[:id] end

  def company_blog
    current_organization.company_blog
  end
  helper_method :company_blog
end