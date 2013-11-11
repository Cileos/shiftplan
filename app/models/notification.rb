module Notification
  def self.destroy_for(thingy)
    Notification::Base.by_notifiable(thingy).each(&:destroy)
  end
end
