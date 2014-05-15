class ApplyPlanTemplateController < BaseController
  defaults :singleton => true
  nested_belongs_to :plan, :organization, :account # must be reverse ?!
  respond_to :js

  def create
    create! do
      if resource.some_shifts_outside_plan_period
        set_flash(:notice, :some_shifts_outside_plan_period)
      else
        set_flash(:notice)
      end

      path = plan_week_mode_path(plan, 'teams_in_week', resource.monday)
      store_undo create: resource.created_schedulings, redirect: path
      path
    end
  end

  private
    def plan
      parent
    end
end
