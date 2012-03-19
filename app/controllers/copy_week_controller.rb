class CopyWeekController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :plan, :singleton => true
  respond_to :js

  def create
    create! { plan_year_week_path parent, resource.target_year, resource.target_week }
  end
end
