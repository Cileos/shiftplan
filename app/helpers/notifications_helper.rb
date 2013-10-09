module NotificationsHelper
  def url_for_notifiable(notifiable)
    case notifiable
    when Comment
      url_for_comment(notifiable)
    when Post
      url_for(nested_resources_for(notifiable))
    when Scheduling
      url_for_scheduling(notifiable)
    end
  end

  def url_for_comment(comment)
    if comment.commentable_type == 'Scheduling'
      url_for_scheduling(comment.commentable)
    elsif comment.commentable_type == 'Post'
      url_for(nested_resources_for(comment.commentable))
    end
  end

  def url_for_scheduling(scheduling)
    plan = scheduling.plan
    organization = plan.organization
    account_organization_plan_employees_in_week_path(
      organization.account,
      organization,
      plan,
      cwyear: scheduling.cwyear, week: scheduling.week)
  end
end
