class CopyWeekController < BaseController
  defaults :singleton => true
  nested_belongs_to :plan, :organization, :account # must be reverse ?!
  respond_to :js

  def create
    create! do
      set_flash(:notice)
      path = plan_week_mode_path(plan, current_plan_mode, resource.monday)

      create_undo create: resource.created_schedulings, redirect: path
      path
    end
  end

  private
    # InheritedResources gives us #parent
    def plan
      parent
    end
end
