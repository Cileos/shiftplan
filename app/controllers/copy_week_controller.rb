class CopyWeekController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :plan, :singleton => true
  respond_to :js

  def create
    create! { current_week_path }
  end

  protected

  def current_week_path
    organization_plan_year_week_path current_organization, parent, resource.target_year, resource.target_week
  end
end
