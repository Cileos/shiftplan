class OrganizationsController < InheritedResources::Base
  belongs_to :account
  load_and_authorize_resource

  def create
    create! { dashboard_path }
  end

  protected

  def interpolation_options
    { organization: resource.name }
  end
end
