class UpcomingSchedulingNotificationGenerator
  def self.generate!
    Scheduling.upcoming_in_the_next_24_hours.each do |scheduling|
      last_notification = Notification::UpcomingScheduling.where(notifiable_id: scheduling.id, notifiable_type: 'Scheduling').order('created_at desc').first
      if !last_notification.present? || last_notification.created_at < scheduling.updated_at
        Notification::UpcomingScheduling.create!(
          notifiable: scheduling,
          employee: scheduling.employee
        ).delay.deliver!
      end
    end
  end
end
