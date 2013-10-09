class SchedulingNotificationMailer < ClockworkMailer

  def new_comment(notification)
    @notification = notification
    @comment      = notification.notifiable
    @scheduling   = @comment.commentable
    I18n.with_locale(notification.user_locale) do
      mail to: notification.employee.user.email, subject: notification.mail_subject
    end
  end
end
