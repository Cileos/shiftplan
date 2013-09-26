class Notification::AnswerOnCommentOnScheduling < Notification::CommentOnScheduling
  def mail_subject
    t(:'mail_subjects.answer_on_comment', name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_texts.answer_on_comment', author_name: comment.author_name, employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day), quickie: scheduling.quickie)
  end
end
