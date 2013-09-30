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
    t(:"mail_subjects.#{tkey}",
      name: comment.author_name)
  end

  def introductory_text
    t(:"introductory_texts.#{tkey}",
      author_name: comment.author_name,
      post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny))
  end

  def blurb
    t(:"blurbs.#{tkey}",
      post_title: truncated_post_title,
      body: truncated_body)
  end

  def truncated_post_title
    post.title.truncate(25, omission: "...")
  end
end
