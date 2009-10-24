module PlanHelper
  def plan_dates(plan)
    I18n.t(:plan_from_to, :start => I18n.l(plan.start.to_date), :end => I18n.l(plan.end.to_date))
  end

  def plan_name_and_dates(plan)
    "#{plan.name} (#{plan_dates(plan)})"
  end
end