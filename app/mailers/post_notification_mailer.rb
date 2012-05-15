class PostNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: 'Shiftplan <no-reply@shiftplan.de>'

  def new_notification(notification)
    @notification = notification
    @post         = notification.post
    mail to: notification.employee.user.email, subject: notification.subject
  end

  alias_method :new_post, :new_notification
  alias_method :new_icomment, :new_notification
end
