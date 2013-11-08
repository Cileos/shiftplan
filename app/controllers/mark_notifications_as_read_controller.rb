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

  def url_for_notifiable(notifiable)
    case notifiable
    when Comment
      url_for_comment(notifiable)
    when Scheduling
      polymorphic_path *nested_show_resources_for(notifiable.decorate)
    else
      nested_resources_for(notifiable)
    end
  end

  def url_for_comment(comment)
    case comment.commentable
    when Scheduling
      polymorphic_path *nested_show_resources_for(comment.commentable.decorate, :comments)
    else
      nested_resources_for(comment.commentable)
    end
  end

end
