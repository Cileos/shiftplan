class Notification::CommentOnPostOfEmployee < Notification::CommentOnPost
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
end
