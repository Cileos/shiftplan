class Notification::UpcomingScheduling < Notification::Base
  def self.mailer_class
    UpcomingSchedulingNotificationMailer
  end

  def self.mailer_action
    :upcoming_scheduling
  end
end
