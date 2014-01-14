class NotificationDestroyer

  attr_reader :notifiable

  def initialize(notifiable)
    @notifiable = notifiable
  end

  def destroy!
    Notification::Base.by_notifiable(notifiable).delete_all
  end
end
