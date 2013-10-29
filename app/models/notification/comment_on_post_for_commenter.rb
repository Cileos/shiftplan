class Notification::CommentOnPostForCommenter < Notification::CommentOnPost
  def mail_subject
    t(:'mail_subject', scope: tscope,
      name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_text', scope: tscope,
      author_name: comment.author_name,
      post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny))
  end
end
