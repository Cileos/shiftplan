class PostNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'

  def new_post(post, employee)
    @post = post
    @employee = employee
    mail from: 'no-reply@shiftplan.com', to: employee.user.email, subject: t(:'post_notification_mailer.new_post.subject')
  end
end
