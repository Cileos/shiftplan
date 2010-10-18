# $LOAD_PATH is not set for views dirs
require File.expand_path('../base', __FILE__)
#require 'activities/base'

module Activities
  class Assignment < Activities::Base
    def to_html
      li summary, :class => 'activity assignment'
    end

    def summary
      alterations = activity.alterations
    
      qualification = alterations[:to][:requirement]

      t(:"activity.assignment.#{activity.action}",
        :user          => activity.user_name, # link to user profile if it still exists
        :started_at    => started_at,
        :employee      => alterations[:to][:assignee],
        :day           => l(alterations[:to][:shift][:start], :format => :short),
        :workplace     => alterations[:to][:shift][:workplace],
        :qualification => qualification
      )
    end
  end
end
