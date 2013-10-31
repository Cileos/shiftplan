class Notification::AnswerOnCommentOnScheduling < Notification::CommentOnScheduling

  def tkey
    :answer_on_comment
  end
end
