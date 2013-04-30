class Notification::CommentOnSchedulingForCommenter < Notification::CommentOnScheduling
  def subject
    t(:'subjects.comment_for_commenter', name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_texts.comment_for_commenter', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end
