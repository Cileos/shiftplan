class UpcomingSchedulingNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: "Clockwork <no-reply@#{Volksplaner.hostname}>"

  def upcoming_scheduling(notification)
  end
end
