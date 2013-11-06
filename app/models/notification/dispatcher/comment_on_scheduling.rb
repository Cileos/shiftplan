class Notification::Dispatcher::CommentOnScheduling < Notification::Dispatcher::Comment

  def create_notifications!
    recipients.each do |employee|
      notification_class = notification_class_for(employee)
      notification_class.create!(notifiable: comment, employee: employee)
    end
  end

  private

  def recipients
    ([organization.owner] +
      organization.planners +
      [scheduling.employee] + # create notification for the employee of the scheduling
      scheduling.commenters - # create notifications for all employees who commented the scheduling before
      [comment.employee] # do not create notification for the commenter itself
    ).compact.select { |e| e.user.present? && e.user.confirmed? }.uniq # do not create notification for employees without a confirmed user
  end

  def scheduling
    @scheduling ||= comment.commentable
  end

  def organization
    @organization ||= scheduling.organization
  end

  def notification_class_for(employee)
    if scheduling.employee == employee # is it a scheduling of the employee?
      Notification::CommentOnSchedulingOfEmployee
    elsif scheduling.commenters.include? employee # has the employee commented on the same scheduling before
      Notification::CommentOnSchedulingForCommenter
    else
      Notification::CommentOnScheduling
    end
  end
end
