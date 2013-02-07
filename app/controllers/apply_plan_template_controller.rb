class ApplyPlanTemplateController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :plan, :singleton => true
  respond_to :js

  def create
    create! do
      if resource.some_shifts_outside_plan_period
        set_flash(:notice, :some_shifts_outside_plan_period)
      else
        set_flash(:notice)
      end
      plan_week_mode_path(plan, 'teams_in_week', resource.target_day)
    end
  end

  private
    def plan
      parent
    end
end
