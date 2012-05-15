module Notification
  def self.create_for(thingy)
    Notification::Dispatcher::Base.create_notifications_for(thingy)
  end
end
