require 'activities/base'

class Activities::Plan < Activities::Base
  def to_html
    li :class => 'activity plan' do
      link_to(summary, '#')
      render_details(:name, :start_date, :end_date)
    end
  end
  
  def summary
    t(:"activity.plan.#{status}",
      :action => action,
      :plan => plan_name,
      :user => activity.user_name, # link to user profile if it still exists
      :started_at => started_at,
      :finished_at => finished_at
    )
  end
  
  def plan_name
    name = activity.alterations[:from][:name] rescue nil # link to the plan if it still exists
    name ||= activity.alterations[:to][:name] rescue nil
    name || activity.object.name rescue ''
  end
end