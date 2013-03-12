# When I go to the page of the plan
#   Or I go to a calendar outside of the plan period
# Then I should be redirected to a valid calendar of the plan
module Volksplaner
  class PlanRedirector

    attr_reader :controller, :plan

    def initialize(controller, plan)
      @controller = controller
      @plan = plan
    end

    def redirect
      controller.redirect_to week_within_plan_path
    end

    def validate_and_redirect(filter)
      if plan.has_period? && (better_path = path_for_filter_not_in_in_period(filter))
        controller.redirect_to better_path
      end
    end

    # cannot use default as the filter has its own mode
    def path_for_filter_not_in_in_period(filter)
      if filter.before_start_of_plan?
        filter.path_to_date( plan.starts_at )
      elsif filter.after_end_of_plan?
        filter.path_to_date( plan.ends_at )
      end
    end

    # default view is employees in week
    def default_calendar_path(*a)
      controller.account_organization_plan_employees_in_week_path(
        plan.organization.account,
        plan.organization,
        plan,
        *a
      )
    end

    def week_path(day)
      default_calendar_path( day.cwyear, day.cweek )
    end

    def week_within_plan_path
      week_path( find_day_within_plan_period )
    end

    def find_day_within_plan_period(day=nil)
      day ||= Time.zone.now
      if plan.has_period?
        period = plan.period
        if period.starts_after?(day)
          plan.starts_at
        elsif period.ends_before?(day)
          plan.ends_at
        else
          day # not limited by the period
        end
      else
        day
      end
    end

  end
end
