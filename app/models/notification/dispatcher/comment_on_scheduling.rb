require 'notification/comment_on_scheduling'
class Notification::Dispatcher::CommentOnScheduling < Notification::Dispatcher::Comment

  def self.create_notifications_for(comment)
    if comment.is_answer? # is the comment an answer on a comment?
      notification_recipients_for(comment).each do |employee|
        notification_class = answer_dispatcher.notification_class_for(comment, employee)
        notification_class.create!(notifiable: comment, employee: employee)
      end
    else
      notification_recipients_for(comment).each do |employee|
        notification_class = self.notification_class_for(comment, employee)
        notification_class.create!(notifiable: comment, employee: employee)
      end
    end
  end

  def self.answer_dispatcher
    Notification::Dispatcher::AnswerOnCommentOnScheduling
  end

  def self.notification_recipients_for(comment)
    scheduling = comment.commentable
    organization = scheduling.organization
    (
      [organization.owner] +
      organization.planners +
      [scheduling.employee] + # sent mail to the employee of the scheduling
      scheduling.commenters - # sent mail to all employees who commented the scheduling before
      [comment.employee] # do not sent mail to the commenter itself
    ).compact.select { |e| e.user.present? }.uniq # do not try to sent mails to employees without a user/a mail address
  end

  def self.notification_class_for(comment, employee)
    scheduling = comment.commentable
    if scheduling.employee == employee # is it a scheduling of the employee?
      Notification::CommentOnSchedulingOfEmployee
    elsif scheduling.commenters.include? employee # has the employee commented on the same scheduling before
      Notification::CommentOnSchedulingForCommenter
    else
      Notification::CommentOnScheduling
    end
  end

  class Notification::Dispatcher::AnswerOnCommentOnScheduling < Notification::Dispatcher::CommentOnScheduling

    def self.notification_class_for(comment, employee)
      scheduling = comment.commentable
      if scheduling.employee == employee # is it a scheduling of the employee?
        if comment.parent.employee == employee # is the parent comment from the employee?
          Notification::AnswerOnCommentOfEmployeeOnSchedulingOfEmployee
        else
          Notification::AnswerOnCommentOnSchedulingOfEmployee
        end
      else
        # it is NOT a scheduling of the employee
        if scheduling.commenters.include? employee # has the employee commented the scheduling before?
          if comment.parent.employee == employee # is the parent comment from the employee?
            Notification::AnswerOnCommentOfEmployeeOnScheduling
          else
            Notification::AnswerOnCommentOnSchedulingForCommenter
          end
        else
          # employee has NOT commented before
          Notification::AnswerOnCommentOnScheduling
        end
      end
    end
  end
end
