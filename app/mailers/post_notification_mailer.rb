class PostNotificationMailer < ClockworkMailer

  def new_notification(notification)
    @notification = notification
    @post         = notification.post

    I18n.with_locale(notification.user_locale) do
      mail to: notification.employee.user.email, subject: notification.mail_subject
    end
  end

  alias_method :new_post, :new_notification
  alias_method :new_comment, :new_notification
end
