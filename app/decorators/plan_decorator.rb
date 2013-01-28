class PlanDecorator < ApplicationDecorator
  decorates :plan

  def selector_for(name, resource=nil, extra=nil)
    case name
    when :plans
      '#plans'
    when :plan
      "table#plans tr#plan_#{resource.id}"
    when :plans_list
      'li.dropdown ul#plans-list'
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

  def update_plans_dropdown(plan)
    select(:plans_list).replace_with(plans_list(plan.organization))
  end

  def plans_list(organization)
    h.render('organizations/plans_list', base: [organization.account, organization],
      organization: organization)
  end

  def respond
    unless errors.empty?
      prepend_errors_for(plan)
    else
      clear_modal
      update_plans
      update_plans_dropdown(plan)
      update_flash
      highlight(plan)
    end
  end
end
