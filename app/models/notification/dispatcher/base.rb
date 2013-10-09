class Notification::Dispatcher::Base

  def self.create_notifications_for(thingy)
    case thingy
    when ::Comment
      Notification::Dispatcher::Comment.create_notifications_for(thingy)
    when ::Post
      Notification::Dispatcher::Post.create_notifications_for(thingy)
    end
  end
end
