class PlanDecorator < ApplicationDecorator
  decorates :plan

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :plans
      'table#plans'
    when :plan
      "table#plans tr#plan_#{resource.id}"
    else
      super
    end
  end

  def update_plans
    select(:plans).replace_with plans_table
  end

  def plans_table
    h.render('plans/table', plans: h.current_organization.plans.order(:name))
  end

  def highlight(plan)
    select(:plan, plan).effect('highlight', {}, 3000)
  end

  def respond
    unless errors.empty?
      prepend_errors_for(plan)
    else
      clear_modal
      update_plans
      update_flash
      highlight(plan)
    end
  end
end
