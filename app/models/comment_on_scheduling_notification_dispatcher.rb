class CommentOnSchedulingNotificationDispatcher < CommentNotificationDispatcher

  def self.create_notifications_for(comment)
    if comment.is_answer? # is the comment an answer on a comment?
      answer_dispatcher.create_notifications_for(comment)
    else
      comment_dispatcher.create_notifications_for(comment)
    end
  end

  def self.answer_dispatcher
    AnswerOnCommentOnSchedulingNotificationDispatcher
  end

  def self.comment_dispatcher
    CommentOnSchedulingNotificationDispatcher
  end

  def self.notification_recipients_for(comment)
    scheduling = comment.commentable
    organization = scheduling.organization
    (
      organization.owners +
      organization.planners +
      [scheduling.employee] + # sent mail to the employee of the scheduling
      scheduling.commenters - # sent mail to all employees who commented the scheduling before
      [comment.employee] # do not sent mail to the commenter itself
    ).select { |e| e.user.present? }.uniq # do not try to sent mails to employees without a user/a mail address
  end

  class AnswerOnCommentOnSchedulingNotificationDispatcher < CommentOnSchedulingNotificationDispatcher
    def self.create_notifications_for(comment)
      notification_recipients_for(comment).each do |employee|
        notification_class_for(comment, employee).create!(notifiable_object: comment, employee: employee)
      end
    end

    def self.notification_class_for(comment, employee)
      scheduling = comment.commentable
      if scheduling.employee == employee # is it a scheduling of the employee?
        if comment.parent.employee == employee # is the parent comment from the employee?
          AnswerOnCommentOfEmployeeOnSchedulingOfEmployeeNotification
        else
          AnswerOnCommentOnSchedulingOfEmployeeNotification
        end
      else
        # it is NOT a scheduling of the employee
        if scheduling.commenters.include? employee # has the employee commented the scheduling before?
          if comment.parent.employee == employee # is the parent comment from the employee?
            AnswerOnCommentOfEmployeeOnSchedulingNotification
          else
            AnswerOnCommentOnSchedulingForCommenterNotification
          end
        else
          # employee has NOT commented before
          AnswerOnCommentOnSchedulingNotification
        end
      end
    end
  end

  class CommentOnSchedulingNotificationDispatcher < CommentOnSchedulingNotificationDispatcher

    def self.create_notifications_for(comment)
      notification_recipients_for(comment).each do |employee|
        notification_class_for(comment, employee).create!(notifiable_object: comment, employee: employee)
      end
    end

    def self.notification_class_for(comment, employee)
      scheduling = comment.commentable
      if scheduling.employee == employee # is it a scheduling of the employee?
        CommentOnSchedulingOfEmployeeNotification
      elsif scheduling.commenters.include? employee # has the employee commented on the same scheduling before
        CommentOnSchedulingForCommenterNotification
      else
        CommentOnSchedulingNotification
      end
    end
  end
end
