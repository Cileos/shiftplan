class Notification::KlassFinder

  attr_reader :notifiable, :recipient

  def find(notifiable, recipient)
    @notifiable = notifiable
    @recipient  =  recipient

    case notifiable
    when ::Post
      Notification::Post
    when ::Comment
      find_klass_for_comment
    end
  end

  private

  def find_klass_for_comment
    case notifiable.commentable
    when ::Post
      find_klass_for_comment_on_post
    when ::Scheduling
      find_klass_for_comment_on_scheduling
    end
  end

  def find_klass_for_comment_on_post
    post = notifiable.commentable
    if recipient == post.author
      Notification::CommentOnPostOfEmployee
    elsif post.commenters.include? recipient
      Notification::CommentOnPostForCommenter
    else
      Notification::CommentOnPost
    end
  end

  def find_klass_for_comment_on_scheduling
    comment    = notifiable
    if comment.is_answer?
      find_klass_for_answer_on_comment_on_scheduling
    else
      find_klass_for_normal_comment_on_scheduling
    end
  end

  def find_klass_for_answer_on_comment_on_scheduling
    comment = notifiable
    scheduling = comment.commentable
    if scheduling.employee == recipient
      if comment.parent.employee == recipient
        Notification::AnswerOnCommentOfEmployeeOnSchedulingOfEmployee
      else
        Notification::AnswerOnCommentOnSchedulingOfEmployee
      end
    else
      if scheduling.commenters.include? recipient
        if comment.parent.employee == recipient
          Notification::AnswerOnCommentOfEmployeeOnScheduling
        else
          Notification::AnswerOnCommentOnSchedulingForCommenter
        end
      else
        Notification::AnswerOnCommentOnScheduling
      end
    end
  end

  def find_klass_for_normal_comment_on_scheduling
    scheduling = notifiable.commentable
    if recipient == scheduling.employee
      Notification::CommentOnSchedulingOfEmployee
    elsif scheduling.commenters.include? recipient
      Notification::CommentOnSchedulingForCommenter
    else
      Notification::CommentOnScheduling
    end
  end
end
