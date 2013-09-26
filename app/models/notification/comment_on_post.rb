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

  def mail_subject
    t(:'mail_subjects.comment_on_post', name: comment.author_name)
  end


  def introductory_text
    t(:'introductory_texts.comment_on_post', author_name: comment.author_name, post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny))
  end
end
