class CommentNotificationDispatcher < NotificationDispatcher

  def self.create_notifications_for(comment)
    case comment.commentable_type
    when 'Scheduling'
      CommentOnSchedulingNotificationDispatcher.create_notifications_for(comment)
    when 'Post'
      # CommentOnPostNotificationDispatcher.create_notifications_for(comment)
    end
  end
end
