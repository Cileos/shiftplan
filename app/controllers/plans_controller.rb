class PlansController < InheritedResources::Base
  load_and_authorize_resource

  respond_to :html, :js

  def begin_of_association_chain
    authorize! :index, Plan
    current_organization
  end

  def create
    create! do |success, failure|
      success.html { redirect_to_current_week }
    end
  end

  def show
    redirect_to_current_week
  end

  private

  def redirect_to_current_week
    redirect_to current_week_path
  end

  def current_week_path
    organization_plan_week_path(current_organization, resource, Date.today.cweek)
  end
end
