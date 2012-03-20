class OrganizationsController < InheritedResources::Base
  load_and_authorize_resource

  protected

  def organization_param; params[:id] end
end