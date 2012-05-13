class SchedulingNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: 'Shiftplan <no-reply@shiftplan.de>'

  def new_comment(notification)
    @notification = notification
    @comment      = notification.notifiable_object
    @scheduling   = @comment.commentable
    mail to: notification.employee.user.email, subject: notification.subject
  end
end
