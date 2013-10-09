class MarkNotificationsAsReadController < ApplicationController

  skip_authorization_check

  before_filter :set_notification,   only: :one
  before_filter :set_notifications,  only: :multiple

  before_filter :authorize_one,      only: :one
  before_filter :authorize_multiple, only: :multiple

  respond_to :js

  def one
    @notification.read_at = Time.zone.now
    @notification.save!
  end

  def multiple
    @notifications.each do |n|
      n.read_at = Time.zone.now
      n.save!
    end
  end

  protected

  def set_notification
    @notification = current_user.unread_notifications.find(params[:id])
  end

  def set_notifications
    @notifications ||=  current_user.unread_notifications.where(id: notification_ids)
  end

  def notification_ids
    params[:notifications].split(',')
  end

  def authorize_multiple
    @notifications.each do |notification|
      authorize! :update, notification
    end
  end

  def authorize_one
    authorize! :update, @notification
  end

end
