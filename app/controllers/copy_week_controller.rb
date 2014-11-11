class CopyWeekController < BaseController
  defaults :singleton => true
  nested_belongs_to :plan, :organization, :account # must be reverse ?!
  respond_to :js, :html

  def create
    create! do |success, failure|
      success.html do
        set_flash(:notice)
        path = plan_week_mode_path(plan, current_plan_mode, resource.monday)

        create_undo create: resource.created_schedulings, redirect: path
        redirect_to path
      end
      failure.html do
        set_flash(:alert)
        redirect_to :back
      end
    end
  end

  private
    # InheritedResources gives us #parent
    def plan
      parent
    end
end
