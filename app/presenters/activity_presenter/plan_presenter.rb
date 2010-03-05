class ActivityPresenter::PlanPresenter < Presenter
  def render
    li :class => 'activity plan' do
      summary + details
    end
  end
  
  def summary
    t(:"activity.plan.#{activity.status}", {
      :action => action,
      :plan => plan,
      :user => activity.user_name,   # link to user profile if it still exists
      :started_at => started_at,
      :finished_at => finished_at
    })
  end
  
  def details
    case activity.action
    when 'create'
      ''
    when 'update'
      table { changes(:from) + changes(:to) }
    when 'destroy'
      ''
    end
  end
  
  def plan
    activity.changes[:from][:name] rescue '' # link to the plan if it still exists
  end
  
  def action
    t(:"activity.plan.action.#{activity.action}", :default => :"activity.action.#{activity.action}")
  end
  
  def started_at
    l(activity.started_at || activity.created_at, :format => :short)
  end
  
  def finished_at
    l(activity.finished_at, :format => :short) if activity.finished_at
  end
  
  def changes(type)
    changes = (activity.changes[type] || [])
    changes.map do |name, value|
      tr do
        th { name == changes.keys.first ? t(:"activity.#{type}") : '' } +
        th { t(:"activity.plan.attributes.#{name}") } + 
        td { value }
      end
    end.join_safe
  end
end
