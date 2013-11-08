class SchedulingDecorator < RecordDecorator
  include TimePeriodFormatter
  include OvernightableDecoratorHelper
  include SchedulableDecoratorHelper

  decorates :scheduling

  def long
    quickie
  end

  def short
    concat hour_range_quickie, team_shortcut
  end

  def team_shortcut
    if team
      team.shortcut
    end
  end

  def metadata
    super.merge({
      start: start_hour,
      length: length_in_hours,
      comments_count: comments_count,
    })
  end

  def cid
    cid_for_overnightable
  end

  def link_to_conflicts
    if conflicting?
      h.link_to '!', h.nested_resources_for(scheduling, :conflicts), class: 'conflict', remote: true
    end
  end

  def link_to_calendar(name, opts={})
    h.link_to(name,
              h.account_organization_plan_employees_in_week_path(
                *h.nested_resources_for(model.plan),
                week: week,
                cwyear: cwyear,
                anchor: "/scheduling/#{cid}"
              )
    )
  end

  def summary
    if team
      if plan
        "#{team.name} (#{plan.name})"
      else
        team.name
      end
    elsif plan
      plan.name
    end
  end


  private
  def scheduling
    source
  end
end
