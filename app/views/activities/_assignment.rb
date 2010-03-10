require 'activities/base'

class Activities::Assignment < Activities::Base
  def content
    li summary, :class => 'activity assignment'
  end

  def summary
    changes = activity.changes
    
    qualification = changes[:to][:requirement]
    qualification = t(:"activity.assignment.qualification", :name => qualification) if qualification

    t(:"activity.assignment.#{action}", {
      :user       => activity.user_name, # link to user profile if it still exists
      :started_at => started_at,
      :employee   => changes[:to][:assignee],
      :day        => l(changes[:to][:shift][:start], :format => :short),
      :workplace  => changes[:to][:shift][:workplace],
      :qualification => qualification
    })
  end
end