require 'activities/base'

class Activities::Shift < Activities::Base
  def to_html
    li :class => 'activity shift' do
      link_to(summary, '#')
      render_details(:start, :end, :requirements)
    end
  end
  
  def summary
    t(:"activity.shift.#{status}",
      :action      => action,
      :workplace   => activity.object ? activity.object.workplace.try(:name) : '',
      :user        => activity.user_name, # link to user profile if it still exists
      :started_at  => started_at,
      :finished_at => finished_at
    )
  end
end