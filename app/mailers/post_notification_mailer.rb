class PostNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: 'Shiftplan <no-reply@shiftplan.de>'

  def new_post(post, employee)
    @post = post
    @employee = employee
    mail to: employee.user.email, subject: t(:'post_notification_mailer.new_post.subject')
  end

  def new_comment(notification)
    @notification = notification
    @post = notification.post
    mail to: notification.employee.user.email, subject: notification.subject
  end
end
