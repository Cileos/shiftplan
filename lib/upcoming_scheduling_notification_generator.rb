class UpcomingSchedulingNotificationGenerator
  def self.generate!
    Scheduling.upcoming_in_the_next_24_hours.each do |scheduling|
      unless Notification::UpcomingScheduling.find_by_notifiable_id_and_notifiable_type(scheduling.id, 'Scheduling').present?
        Notification::UpcomingScheduling.create!(
          notifiable: scheduling,
          employee: scheduling.employee
        )
      end
    end
  end
end
