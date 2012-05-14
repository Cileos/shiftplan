class Notification::CommentOnScheduling < Notification::Comment

  def self.mailer_class
    SchedulingNotificationMailer
  end

  def self.mailer_action
    'new_comment'
  end

  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subjects.comment', name: comment.author_name)
  end

  def scheduling
    comment.commentable
  end

  def comment
    notifiable
  end

  def introductory_text
    I18n.t(:'scheduling_notification_mailer.new_comment.introductory_texts.comment', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end

class Notification::CommentOnSchedulingOfEmployee < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subjects.comment_on_scheduling_of_employee', name: comment.author_name)
  end

  def introductory_text
    I18n.t(:'scheduling_notification_mailer.new_comment.introductory_texts.comment_on_scheduling_of_employee', author_name: comment.author_name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end

class Notification::CommentOnSchedulingForCommenter < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subjects.comment_for_commenter', name: comment.author_name)
  end

  def introductory_text
    I18n.t(:'scheduling_notification_mailer.new_comment.introductory_texts.comment_for_commenter', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end

class Notification::AnswerOnCommentOnScheduling < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subjects.answer_on_comment', name: comment.author_name)
  end

  def introductory_text
    I18n.t(:'scheduling_notification_mailer.new_comment.introductory_texts.answer_on_comment', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end

class Notification::AnswerOnCommentOfEmployeeOnSchedulingOfEmployee < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subjects.answer_on_comment_of_employee_on_scheduling_of_employee', name: comment.author_name)
  end

  def introductory_text
    I18n.t(:'scheduling_notification_mailer.new_comment.introductory_texts.answer_on_comment_of_employee_on_scheduling_of_employee', author_name: comment.author_name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end

class Notification::AnswerOnCommentOfEmployeeOnScheduling < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subjects.answer_on_comment_of_employee', name: comment.author_name)
  end

  def introductory_text
    I18n.t(:'scheduling_notification_mailer.new_comment.introductory_texts.answer_on_comment_of_employee', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end

class Notification::AnswerOnCommentOnSchedulingOfEmployee < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subjects.answer_on_comment_on_scheduling_of_employee', name: comment.author_name)
  end

  def introductory_text
    I18n.t(:'scheduling_notification_mailer.new_comment.introductory_texts.answer_on_comment_on_scheduling_of_employee', author_name: comment.author_name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end

class Notification::AnswerOnCommentOnSchedulingForCommenter < Notification::CommentOnScheduling
  def subject
    I18n.t(:'scheduling_notification_mailer.new_comment.subjects.answer_on_comment_for_commenter', name: comment.author_name)
  end

  def introductory_text
    I18n.t(:'scheduling_notification_mailer.new_comment.introductory_texts.answer_on_comment_for_commenter', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end
