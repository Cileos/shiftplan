class SchedulingNotificationMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default from: 'Shiftplan <no-reply@shiftplan.de>'

  def new_comment(comment, employee)
    @comment = comment
    @employee = employee
    @scheduling = comment.commentable
    @is_answer = comment.parent.present? ? true : false
    subject = if @is_answer
      if comment.parent.employee == employee
        t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment_for_author', name: comment.employee.name)
      else
        t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment', name: comment.employee.name)
      end
    else
      if @scheduling.employee == employee
        # It is the employee's scheduling that was commented on
        t(:'scheduling_notification_mailer.new_comment.subject_for_comment_on_scheduling_of_employee', name: comment.employee.name)
      elsif @scheduling.comments.map { |c| c.employee }.include? employee
        # Employee commented on same scheduling before
        t(:'scheduling_notification_mailer.new_comment.subject_for_comment_for_commenter', name: comment.employee.name)
      else
        # Employee is neither the employee of the scheduling nor has commented on the same scheduling before.
        # At the moment, only owners and planners will receive a notification mail in this case.
        t(:'scheduling_notification_mailer.new_comment.subject_for_comment', name: comment.employee.name)
      end
    end
    mail to: employee.user.email, subject: subject
  end
end
