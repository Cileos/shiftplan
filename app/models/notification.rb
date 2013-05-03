module Notification
  def self.create_for(thingy)
    Notification::Dispatcher::Base.create_notifications_for(thingy)
  end

  def self.destroy_for(thingy)
    Notification::Base.by_notifiable(thingy).each(&:destroy)
  end
end
