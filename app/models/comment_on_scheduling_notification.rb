class CommentOnSchedulingNotification < CommentNotification
  after_create :send!

  def subject
    'test subject'
  end

  def scheduling
    comment.commentable
  end

  def comment
    notifiable_object
  end

  def introductory_text
    "#{comment.employee.name} hat eine Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) kommentiert:"
  end

  protected

  def send!
    SchedulingNotificationMailer.new_comment(self).deliver
  end
end

class CommentOnSchedulingOfEmployeeNotification < CommentOnSchedulingNotification
  def introductory_text
    "#{comment.employee.name} hat eine Ihrer Schichten am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) kommentiert:"
  end
end

class CommentOnSchedulingForCommenterNotification < CommentOnSchedulingNotification
  def introductory_text
    "#{comment.employee.name} hat eine Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) kommentiert, die Sie auch kommentiert haben:"
  end
end

class AnswerOnCommentOnSchedulingNotification < CommentOnSchedulingNotification
  def introductory_text
    "#{comment.employee.name} hat auf einen Kommentar zu einer Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet:"
  end
end

class AnswerOnCommentOfEmployeeOnSchedulingOfEmployeeNotification < CommentOnSchedulingNotification
  def introductory_text
    "#{comment.employee.name} hat auf Ihren Kommentar zu einer Ihrer Schichten am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet:"
  end
end

class AnswerOnCommentOfEmployeeOnSchedulingNotification
  def introductory_text
    "#{comment.employee.name} hat auf Ihren Kommentar zu einer Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet:"
  end
end

class AnswerOnCommentOnSchedulingOfEmployeeNotification
  def introductory_text
    "#{comment.employee.name} hat auf einen Kommentar zu einer Ihrer Schichten am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet:"
  end
end

class AnswerOnCommentOnSchedulingForCommenterNotification < CommentOnSchedulingNotification
  def introductory_text
    "#{comment.employee.name} hat auf einen Kommentar zu einer Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet. Diese Schicht haben Sie ebenfalls kommentiert:"
  end
end
