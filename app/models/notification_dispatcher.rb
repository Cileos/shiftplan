class NotificationDispatcher

  def self.create_notifications_for(object)
    case object.class.name
    when 'Comment'
      CommentNotificationDispatcher.create_notifications_for(object)
    end
  end
end
