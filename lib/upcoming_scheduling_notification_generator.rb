class UpcomingSchedulingNotificationGenerator
  def self.generate!
    Scheduling.starting_in_the_next('24 hours').each do |scheduling|
      user = scheduling.employee.try(:user)
      if user.present? && user.confirmed?
        last_notification = Notification::UpcomingScheduling.by_notifiable(scheduling).order('created_at desc').first
        if !last_notification.present? || last_notification.created_at < scheduling.updated_at
          notification = Notification::UpcomingScheduling.create!(
            notifiable: scheduling,
            employee: scheduling.employee
          )
          notification.send_mail
        end
      end
    end
  end
end
