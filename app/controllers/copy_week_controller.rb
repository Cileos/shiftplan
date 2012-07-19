class CopyWeekController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :plan, :singleton => true
  respond_to :js

  def create
    create! { plan_week_mode_path(plan, current_plan_mode, resource.target_day) }
  end

  private
    # InheritedResources gives us #parent
    def plan
      parent
    end
end
