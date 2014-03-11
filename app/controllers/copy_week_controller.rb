class CopyWeekController < BaseController
  nested_belongs_to :account, :organization, :plan, :singleton => true
  respond_to :js

  def create
    create! do
      set_flash(:notice)
      path = plan_week_mode_path(plan, current_plan_mode, resource.monday)

      store_undo create: resource.created_schedulings, redirect: path
      path
    end
  end

  private
    # InheritedResources gives us #parent
    def plan
      parent
    end
end
