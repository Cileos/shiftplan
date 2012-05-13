class Notification::Dispatcher::Base

  def self.create_notifications_for(object)
    case object.class.name
    when 'Comment'
      Notification::Dispatcher::Comment.create_notifications_for(object)
    end
  end
end
