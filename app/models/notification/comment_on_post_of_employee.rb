class Notification::CommentOnPostOfEmployee < Notification::CommentOnPost
  def subject
    t(:'subjects.comment_on_post_of_employee', name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_texts.comment_on_post_of_employee', author_name: comment.author_name, post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny))
  end
end
