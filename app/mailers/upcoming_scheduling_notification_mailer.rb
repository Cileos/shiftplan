class UpcomingSchedulingNotificationMailer < ClockworkMailer

  def upcoming_scheduling(notification)
    mail to: notification.employee.user.email,
      subject: t(:'mailer.upcoming_scheduling_notification.upcoming_scheduling.subject')
  end
end
