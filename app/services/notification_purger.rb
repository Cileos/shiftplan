class NotificationPurger
  def self.purge!
    Notification::Base.not_upcoming.older_than('3 months').each(&:destroy)
    Notification::UpcomingScheduling.with_scheduling_ended.each(&:destroy)
  end
end
