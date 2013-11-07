class Notification::RecipientsFinder

  attr_reader :notifiable

  def find(notifiable)
    @notifiable = notifiable

    case notifiable
    when ::Post
      recipients_for_post
    when ::Comment
      recipients_for_comment
    end
  end

  private

  def recipients_for_post
    notifiable.organization.employees.select do |e|
      e.user.present? && e.user.confirmed? &&
        notifiable.author != e
    end
  end

  def recipients_for_comment
    case notifiable.commentable
    when ::Scheduling
      recipients_for_comment_on_scheduling
    end
  end

  def recipients_for_comment_on_scheduling
    comment = notifiable
    scheduling = comment.commentable
    organization = scheduling.plan.organization
    (organization.planners +
     [scheduling.employee] +
     scheduling.commenters -
     [comment.employee]
    ).compact.select do |e|
      e.user.present? && e.user.confirmed?
    end.uniq
  end

end
