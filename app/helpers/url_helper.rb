# path helpers that are too dynamic for config/routes.rb
module UrlHelper
  def plan_week_mode_path(plan, mode, day)
    send("organization_plan_#{mode}_path", plan.organization, plan, year: day.year, week: day.cweek)
  end
end
