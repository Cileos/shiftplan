class CopyWeekController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :plan, :singleton => true
  respond_to :js

  def create
    create! do
      set_flash(:notice)
      plan_week_mode_path(plan, current_plan_mode, resource.monday)
    end
  end

  private
    # InheritedResources gives us #parent
    def plan
      parent
    end
end
