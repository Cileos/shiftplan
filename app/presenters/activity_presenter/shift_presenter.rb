class ActivityPresenter::ShiftPresenter < ActivityPresenter
  def content
    li :class => 'activity shift' do
      self << link_to(summary, '#')
      render_details(:start, :end, :requirements)
    end
  end
  
  def summary
    t(:"activity.shift.#{status}", {
      :action => action,
      :workplace => activity.object.workplace.name,
      :user => activity.user_name, # link to user profile if it still exists
      :started_at => started_at,
      :finished_at => finished_at
    })
  end
end