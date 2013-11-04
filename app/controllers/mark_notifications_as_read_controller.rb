class MarkNotificationsAsReadController < ApplicationController

  skip_authorization_check

  before_filter :authorize_one,      only: :one
  before_filter :authorize_multiple, only: :multiple

  respond_to :js, :html

  def one
    notification.read_at = Time.zone.now
    notification.save!

    respond_to do |format|
      format.html  { redirect_to url_for_notifiable(notification.notifiable) }
      format.js    { }
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
    @notification ||= current_user.unread_notifications.find(params[:id])
  end

  def notifications
    @notifications ||=  current_user.unread_notifications.where(id: notification_ids)
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

  # TODO: try to move to nested_resources_for helper
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
