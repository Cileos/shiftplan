module ActivitiesHelper
  def activities_list(activities)
    activities.map do |activity| 
      presenter_for(activity, "activity/#{activity.object_type}").to_s
    end.join_safe
  end
end