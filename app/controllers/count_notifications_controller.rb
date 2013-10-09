class CountNotificationsController < ApplicationController

  skip_authorization_check

  before_filter :set_notifications
  before_filter :authorize_notifications

  respond_to :js

  def count
    @count = @notifications.count
  end

  protected

  def set_notifications
    @notifications ||=  current_user.unread_notifications
  end

  def authorize_notifications
    @notifications.each do |notification|
      authorize! :read, notification
    end
  end

end
