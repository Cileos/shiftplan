class Notification::Dispatcher::AnswerOnCommentOnScheduling < Notification::Dispatcher::CommentOnScheduling

  def create_notifications!
    recipients.each do |employee|
      notification_class = notification_class_for(employee)
      notification_class.create!(notifiable: comment, employee: employee)
    end
  end

  private

  def notification_class_for(employee)
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
