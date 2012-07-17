class Notification::CommentOnPost < Notification::Comment

  def self.mailer_class
    PostNotificationMailer
  end

  def self.mailer_action
    :new_comment
  end

  def post
    comment.commentable
  end

  def subject
    t(:'subjects.comment_on_post', name: comment.author_name)
  end


  def introductory_text
    t(:'introductory_texts.comment_on_post', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(comment.created_at, format: :tiny), quickie: scheduling.quickie)
  end
end
