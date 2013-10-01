desc "Generate Upcoming Scheduling Notifications"
namespace :notification do
  task :generate_upcoming_scheduling_notifications => :environment do
    require 'upcoming_scheduling_notification_generator'

    UpcomingSchedulingNotificationGenerator.generate!
  end
end
