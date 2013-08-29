class UpcomingSchedulingNotificationGenerator
  def self.generate!
    Scheduling.upcoming_in_the_next_24_hours.each do |scheduling|
      Notification::UpcomingScheduling.create!(
        notifiable: scheduling,
        employee: scheduling.employee
      )
    end
  end
end
