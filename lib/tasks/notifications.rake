namespace :notification do

  desc "Generate Upcoming Scheduling Notifications"
  task :generate_upcoming_scheduling_notifications => :environment do
    require 'upcoming_scheduling_notification_generator'

    UpcomingSchedulingNotificationGenerator.generate!
  end

  desc "Purge old Notifications"
  task :purge_old_notifications => :environment do
    NotificationPurger.purge!
  end
end
