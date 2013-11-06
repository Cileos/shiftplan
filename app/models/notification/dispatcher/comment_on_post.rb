class Notification::Dispatcher::CommentOnPost < Notification::Dispatcher::Comment

  def create_notifications!
    recipients.each do |employee|
      notification_class = notification_class_for(employee)
      notification_class.create!(notifiable: comment, employee: employee)
    end
  end

  private

  def post
    @post ||= comment.commentable
  end

  def author
    comment.employee
  end

  def recipients
    # An owner not being a member but the author or a commenter of the post,
    # should be notified. All other employees who are able to write posts and
    # comments are employees of the organization anyway.
    (post.organization.employees + [post.author] + post.commenters).select do |e|
      e.user.present? && e.user.confirmed? &&
        author != e
    end.uniq
  end

  def notification_class_for(employee)
    if post.author == employee
      Notification::CommentOnPostOfEmployee
    elsif post.commenters.include? employee
      Notification::CommentOnPostForCommenter
    else
      Notification::CommentOnPost
    end
  end

end
