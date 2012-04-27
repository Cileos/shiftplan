class PostNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: 'Shiftplan <no-reply@shiftplan.de>'

  def new_post(post, employee)
    @post = post
    @employee = employee
    mail to: employee.user.email, subject: t(:'post_notification_mailer.new_post.subject')
  end

  def new_comment(comment, employee)
    @comment = comment
    @employee = employee
    subject = if comment.commentable.author == employee
      t(:'post_notification_mailer.new_comment.subject_for_post_author')
    else
      t(:'post_notification_mailer.new_comment.subject_for_commenter')
    end
    mail to: employee.user.email, subject: subject
  end
end
