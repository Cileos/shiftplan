require 'activities/base'

class Activities::Assignment < Activities::Base
  def content
    li summary, :class => 'activity assignment'
  end

  def summary
    changes = activity.changes
    
    qualification = changes[:to][:requirement]

    t(:"activity.assignment.#{activity.action}", {
      :user       => activity.user_name, # link to user profile if it still exists
      :started_at => started_at,
      :employee   => changes[:to][:assignee],
      :day        => l(changes[:to][:shift][:start], :format => :short),
      :workplace  => changes[:to][:shift][:workplace],
      :qualification => qualification
    })
  end
end