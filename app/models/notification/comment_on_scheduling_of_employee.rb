class Notification::CommentOnSchedulingOfEmployee < Notification::CommentOnScheduling
  def subject
    t(:'subjects.comment_on_scheduling_of_employee', name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_texts.comment_on_scheduling_of_employee', author_name: comment.author_name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end
