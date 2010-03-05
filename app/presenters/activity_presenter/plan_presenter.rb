class ActivityPresenter::PlanPresenter < Presenter
  def render
    li :class => 'activity plan' do
      summary + details
    end
  end
  
  def summary
    t(:"activity.plan.#{status}", {
      :action => action,
      :plan => plan_name,
      :user => activity.user_name, # link to user profile if it still exists
      :started_at => started_at,
      :finished_at => finished_at
    })
  end
  
  def details
    case activity.action
    when 'update'
      table { changes(:from) + changes(:to) }
    else
      table { changes(:to, :label => false ) }
    end
  end
  
  def status
    activity.started_at == activity.finished_at ? activity.status : :unaggregated
  end
  
  def plan_name
    name = activity.changes[:from][:name] rescue nil # link to the plan if it still exists
    name ||= activity.changes[:to][:name] rescue nil
    name || activity.object.name rescue ''
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
  
  def changes(type, options = {})
    options[:label] = true unless options.key?(:label)
    changes = (activity.changes[type] || {})
    attr_names = [:name, :start_date, :end_date]

    attr_names.map do |name|
      value = changes[name]
      tr do
        (options[:label] ? th(:class => :label) { name == attr_names.first ? t(:"activity.#{type}") : '' } : '').html_safe +
        th { t(:"activity.plan.attributes.#{name}") } + 
        td { DateTime == value || Date === value ? l(value, :format => :short) : value }
      end if changes.key?(name)
    end.compact.join_safe
  end
end
