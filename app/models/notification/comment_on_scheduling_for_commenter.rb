class Notification::CommentOnSchedulingForCommenter < Notification::CommentOnScheduling

  def tkey
    :comment_for_commenter
  end
end
