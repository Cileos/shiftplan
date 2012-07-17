class Notification::CommentOnPostForCommenter < Notification::CommentOnPost
  def subject
    t(:'subjects.comment_on_post_for_commenter', name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_texts.comment_on_post_for_commenter', author_name: comment.author_name, post_title: post.title,
      date: I18n.l(comment.created_at, format: :tiny))
  end
end
