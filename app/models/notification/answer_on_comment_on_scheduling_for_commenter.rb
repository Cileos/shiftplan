class Notification::AnswerOnCommentOnSchedulingForCommenter < Notification::CommentOnScheduling

  def tkey
    :answer_on_comment_for_commenter
  end
end
