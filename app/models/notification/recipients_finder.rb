class Notification::RecipientsFinder

  attr_reader :notifiable

  def find(notifiable)
    @notifiable = notifiable

    case notifiable
    when ::Post
      recipients_for_post
    when ::Comment
      recipients_for_comment
    end.select do |r|
      r.user.present? && r.user.confirmed?
    end.compact.uniq
  end

  private

  def recipients_for_post
    notifiable.organization.employees.select do |e|
      notifiable.author != e
    end
  end

  def recipients_for_comment
    case notifiable.commentable
    when ::Scheduling
      recipients_for_comment_on_scheduling
    when ::Post
      recipients_for_comment_on_post
    end
  end

  def recipients_for_comment_on_scheduling
    comment = notifiable
    scheduling = comment.commentable
    organization = scheduling.plan.organization
    (organization.planners +
     [scheduling.employee] +
     scheduling.commenters -
     [comment.employee])
  end

  def recipients_for_comment_on_post
    # An owner not being a member but the author or a commenter of the post,
    # should be notified. All other employees who are able to write posts and
    # comments are employees of the organization anyway.
    post = notifiable.commentable
    (post.organization.employees + [post.author] + post.commenters).select do |e|
      notifiable.author != e
    end
  end

end
