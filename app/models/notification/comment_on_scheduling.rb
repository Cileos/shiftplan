class Notification::CommentOnScheduling < Notification::Comment
  after_create :deliver!

  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subject_for_comment', name: comment.author_name)
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

  def deliver!
    SchedulingNotificationMailer.new_comment(self).deliver
  end
end

class Notification::CommentOnSchedulingOfEmployee < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subject_for_comment_on_scheduling_of_employee', name: comment.author_name)
  end

  def introductory_text
    "#{comment.employee.name} hat eine Ihrer Schichten am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) kommentiert:"
  end
end

class Notification::CommentOnSchedulingForCommenter < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subject_for_comment_for_commenter', name: comment.author_name)
  end

  def introductory_text
    "#{comment.employee.name} hat eine Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) kommentiert, die Sie auch kommentiert haben:"
  end
end

class Notification::AnswerOnCommentOnScheduling < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment', name: comment.author_name)
  end

  def introductory_text
    "#{comment.employee.name} hat auf einen Kommentar zu einer Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet:"
  end
end

class Notification::AnswerOnCommentOfEmployeeOnSchedulingOfEmployee < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment_of_employee_on_scheduling_of_employee', name: comment.author_name)
  end

  def introductory_text
    "#{comment.employee.name} hat auf Ihren Kommentar zu einer Ihrer Schichten am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet:"
  end
end

class Notification::AnswerOnCommentOfEmployeeOnScheduling < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment_of_employee', name: comment.author_name)
  end

  def introductory_text
    "#{comment.employee.name} hat auf Ihren Kommentar zu einer Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet:"
  end
end

class Notification::AnswerOnCommentOnSchedulingOfEmployee < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment_on_scheduling_of_employee', name: comment.author_name)
  end

  def introductory_text
    "#{comment.employee.name} hat auf einen Kommentar zu einer Ihrer Schichten am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet:"
  end
end

class Notification::AnswerOnCommentOnSchedulingForCommenter < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subject_for_answer_on_comment_for_commenter', name: comment.author_name)
  end

  def introductory_text
    "#{comment.employee.name} hat auf einen Kommentar zu einer Schicht von #{scheduling.employee.name} am #{I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day)} (#{scheduling.quickie}) geantwortet. Diese Schicht haben Sie ebenfalls kommentiert:"
  end
end
