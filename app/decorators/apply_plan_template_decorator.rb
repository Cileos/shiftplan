class ApplyPlanTemplateDecorator < ApplicationDecorator
  def plan_templates_for_select
    plan.organization.plan_templates.map do |plan_template|
      [plan_template.name, plan_template.id]
    end
  end
end
