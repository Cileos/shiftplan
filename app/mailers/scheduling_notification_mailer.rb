class SchedulingNotificationMailer < ClockworkMailer

  def new_comment(notification)
    @notification = notification
    @comment      = notification.notifiable
    @scheduling   = @comment.commentable
    mail to: notification.employee.user.email, subject: notification.subject
  end
end
