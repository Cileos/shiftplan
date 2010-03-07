class ActivityPresenter < Minimal::Presenter
  def render_details(*attr_names)
    case activity.action
    when 'update'
      table { render_changes(:from, attr_names) + render_changes(:to, attr_names) }
    else
      table { render_changes(:to, attr_names, :label => false ) }
    end
  end
  
  def render_changes(type, attr_names, options = {})
    options[:label] = true unless options.key?(:label)
    changes = (activity.changes[type] || {})

    attr_names.map do |name|
      value = changes[name]
      tr do
        th(:class => :label) { name == attr_names.first ? t(:"activity.#{type}") : '' } if options[:label]
        th { t(:"activity.#{object_type}.attributes.#{name}") }
        td { format_value(value) }
      end if changes.key?(name)
    end
  end
  
  def object_type
    activity.object_type.underscore
  end
  
  def status
    activity.started_at == activity.finished_at ? activity.status : :unaggregated
  end
  
  def action
    key = :"activity.#{object_type}.action.#{activity.action}"
    default = :"activity.action.#{activity.action}"
    t(key, :default => default)
  end
  
  def started_at
    l(activity.started_at || activity.created_at, :format => :short)
  end
  
  def finished_at
    l(activity.finished_at, :format => :short) if activity.finished_at
  end
  
  def format_value(value)
    case value
    when Array
      value.map { |value| format_value(value) }.join_safe(', ')
    when DateTime, Date, Time
      l(value, :format => :short)
    else
      value
    end
  end
end
