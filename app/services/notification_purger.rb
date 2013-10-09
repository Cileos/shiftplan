class NotificationPurger
  def self.purge!
    Notification::Base.not_upcoming.older_than('3 months').each do |n|
      n.destroy
    end
    Notification::UpcomingScheduling.with_scheduling_ended.each do |n|
      n.destroy
    end
  end
end
