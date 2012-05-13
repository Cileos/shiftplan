class CommentOnSchedulingNotification < CommentNotification
  after_create :send!

  def send!
    SchedulingNotificationMailer.new_comment(self).deliver
  end
end

class CommentOnSchedulingOfEmployeeNotification < CommentOnSchedulingNotification
end

class CommentOnSchedulingForCommenterNotification < CommentOnSchedulingNotification
end

class AnswerOnCommentOnSchedulingNotification < CommentOnSchedulingNotification
end

class AnswerOnCommentOfEmployeeOnSchedulingOfEmployeeNotification < CommentOnSchedulingNotification
end

class AnswerOnCommentOnSchedulingForCommenterNotification < CommentOnSchedulingNotification
end
