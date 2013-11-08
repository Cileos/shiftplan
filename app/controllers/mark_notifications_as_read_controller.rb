class MarkNotificationsAsReadController < ApplicationController

  skip_authorization_check

  before_filter :authorize_one,      only: :one
  before_filter :authorize_multiple, only: :multiple

  respond_to :js, :html

  def one
    notification.mark_as_read!

    respond_to do |format|
      format.html  { redirect_to url_for_notifiable(notification.notifiable) }
      format.js
    end
  end

  def multiple
    notifications.each do |n|
      n.read_at = Time.zone.now
      n.save!
    end
  end

  protected

  def notification
    @notification = current_user.notifications.find(params[:id])
  end

  def notifications
    @notifications ||=  current_user.notifications.unread.where(id: notification_ids)
  end

  def notification_ids
    params[:notifications].split(',')
  end

  def authorize_multiple
    notifications.each do |notification|
      authorize! :update, notification
    end
  end

  def authorize_one
    authorize! :update, notification
  end

  # FIXME: try extend nested_resources_for to implement context specific urls
  # for notification hub
  def url_for_notifiable(notifiable)
    case notifiable
    when Comment
      url_for_comment(notifiable)
    when Post
      nested_resources_for(notifiable)
    when Scheduling
      url_for_scheduling(notifiable)
    end
  end

  def url_for_comment(comment)
    if comment.commentable_type == 'Scheduling'
      url_for_scheduling(comment.commentable)
    elsif comment.commentable_type == 'Post'
      nested_resources_for(comment.commentable) # post
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
