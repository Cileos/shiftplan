class Notification::CommentOnPostOfEmployee < Notification::CommentOnPost
  def mail_subject_options
    { name: comment.author_name }
  end

  def introductory_text_options
    {
      author_name: comment.author_name,
      post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny)
    }
  end
end
