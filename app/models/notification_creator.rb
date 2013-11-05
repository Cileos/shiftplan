class NotificationCreator
  attr_reader :origin

  def initialize(origin)
    @origin = origin
  end

  def create!
    notification_dispatcher.create_notifications!
  end

  private

  def notification_dispatcher
    case origin
    when ::Comment
      comment_notification_dispatcher
    when ::Post
      Notification::Dispatcher::Post.new(origin)
    end
  end

  def comment_notification_dispatcher
    case origin.commentable
    when ::Scheduling
      Notification::Dispatcher::CommentOnScheduling.new(origin)
    when ::Post
      Notification::Dispatcher::CommentOnPost.new(origin)
    end
  end
end
