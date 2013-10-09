class Notification::Dispatcher::Comment < Notification::Dispatcher::Base

  def self.create_notifications_for(comment)
    case comment.commentable
    when ::Scheduling
      Notification::Dispatcher::CommentOnScheduling.create_notifications_for(comment)
    when ::Post
      Notification::Dispatcher::CommentOnPost.create_notifications_for(comment)
    end
  end
end
