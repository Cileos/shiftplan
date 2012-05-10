class SchedulingNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: 'Shiftplan <no-reply@shiftplan.de>'

  def new_comment(comment, employee)
    @comment = comment
    @employee = employee
    @scheduling = comment.commentable
    @is_answer = comment.parent.present? ? true : false
    if @is_answer
      subject = if comment.parent.employee == employee
        t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment_for_author', name: comment.employee.name)
      else
        t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment', name: comment.employee.name)
      end
      mail to: employee.user.email, subject: subject
    end
  end
end
