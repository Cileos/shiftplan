class Notification::Dispatcher::CommentOnPost < Notification::Dispatcher::Comment

  def self.create_notifications_for(comment)
    notification_recipients_for(comment).each do |employee|
      notification_class = notification_class_for(comment, employee)
      notification_class.create!(notifiable: comment, employee: employee)
    end
  end

  def self.notification_recipients_for(comment)
    post = comment.commentable
    post.organization.employees.select do |e|
      e.user.present? && comment.employee != e && (post.author == e || post.commenters.include?(e))
    end
  end

  def self.notification_class_for(comment, employee)
    post = comment.commentable
    if post.author == employee
      Notification::CommentOnPostOfEmployee
    elsif post.commenters.include? employee
      Notification::CommentOnPostForCommenter
    else
      Notification::CommentOnPost
    end
  end

end
