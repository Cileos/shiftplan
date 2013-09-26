class UpcomingSchedulingNotificationMailer < ClockworkMailer

  def upcoming_scheduling(notification)
    @notification             = notification
    @scheduling               = notification.notifiable
    plan                      = @scheduling.plan
    organization              = plan.organization
    account                   = organization.account

    I18n.with_locale(notification.user_locale) do
      mail to: notification.employee.user.email,
        subject: t(:'mailer.upcoming_scheduling_notification.upcoming_scheduling.subject',
                  account: account.name,
                  organization: organization.name,
                  plan: plan.name)
    end
  end
end
