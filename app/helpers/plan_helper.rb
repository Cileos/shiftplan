module PlanHelper
  def plan_dates(plan)
    I18n.t(:plan_from_to, :start_date => I18n.l(plan.start_date), :end_date => I18n.l(plan.end_date))
  end

  def plan_name_and_dates(plan)
    "#{plan.name} (#{plan_dates(plan)})"
  end
end
