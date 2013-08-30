class UpcomingSchedulingNotificationGenerator
  def self.generate!
    Scheduling.upcoming_in_the_next_24_hours.each do |scheduling|
      if scheduling.employee.try(:user).present?
        last_notification = Notification::UpcomingScheduling.by_notifiable(scheduling).order('created_at desc').first
        if !last_notification.present? || last_notification.created_at < scheduling.updated_at
          Notification::UpcomingScheduling.create!(
            notifiable: scheduling,
            employee: scheduling.employee
          )
        end
      end
    end
  end
end
