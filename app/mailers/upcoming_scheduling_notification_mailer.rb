class UpcomingSchedulingNotificationMailer < ClockworkMailer

  def upcoming_scheduling(notification)
    @notification             = notification
    @scheduling               = notification.notifiable

    I18n.with_locale(notification.user_locale) do
      mail(to: notification.employee.user.email, subject: notification.mail_subject)
    end
  end
end
