# $LOAD_PATH is not set for views dirs
require File.expand_path('../base', __FILE__)
#require 'activities/base'

module Activities
  class Shift < Activities::Base
    def to_html
      li :class => 'activity shift' do
        link_to(summary, '#')
        render_details(:start, :end, :requirements)
      end
    end
  
    def summary
      t(:"activity.shift.#{status}",
        :action      => action,
        :workplace   => activity.activity_object ? activity.activity_object.workplace.try(:name) : '',
        :user        => activity.user_name, # link to user profile if it still exists
        :started_at  => started_at,
        :finished_at => finished_at
      )
    end
  end
end
