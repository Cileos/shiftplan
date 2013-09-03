class UpcomingSchedulingNotificationMailer < ClockworkMailer

  def upcoming_scheduling(notification)
    set_locale(notification)
    @notification = notification
    @scheduling = notification.notifiable
    plan = @scheduling.plan
    organization = plan.organization
    account = organization.account

    mail to: notification.employee.user.email,
      subject: t(:'mailer.upcoming_scheduling_notification.upcoming_scheduling.subject',
                account: account.name,
                organization: organization.name,
                plan: plan.name)
  end

  def set_locale(notification)
    user_locale = notification.employee.user.locale
    I18n.locale = user_locale.present? ? user_locale.to_sym : I18n.default_locale
  end

end
