class PostNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: 'Shiftplan <no-reply@shiftplan.de>'

  def new_post(notification)
    @notification = notification
    @post         = notification.post
    mail to: notification.employee.user.email, subject: notification.subject
  end

  def new_comment(notification)
    @notification = notification
    @post         = notification.post
    mail to: notification.employee.user.email, subject: notification.subject
  end
end
