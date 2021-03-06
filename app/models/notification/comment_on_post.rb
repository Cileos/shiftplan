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

  def introductory_text_options
    {
      author_name: comment.author_name,
      post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny)
    }
  end

  def blurb_options
    super.merge(post_title: truncated_post_title)
  end

  def truncated_post_title
    post.title.truncate(25, omission: "...")
  end
end
