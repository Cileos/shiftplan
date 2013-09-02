class UpcomingSchedulingNotificationMailer < ClockworkMailer

  def upcoming_scheduling(notification)
    set_locale(notification)
    @notification = notification
    @scheduling = notification.notifiable
    mail to: notification.employee.user.email,
      subject: t(:'mailer.upcoming_scheduling_notification.upcoming_scheduling.subject')
  end

  def set_locale(notification)
    user_locale = notification.employee.user.locale
    I18n.locale = user_locale.present? ? user_locale.to_sym : I18n.default_locale
  end

end
