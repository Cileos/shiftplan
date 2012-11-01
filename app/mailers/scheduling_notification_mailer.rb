class SchedulingNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: "Clockwork <no-reply@#{Volksplaner.hostname}>"

  def new_comment(notification)
    @notification = notification
    @comment      = notification.notifiable
    @scheduling   = @comment.commentable
    mail to: notification.employee.user.email, subject: notification.subject
  end
end
