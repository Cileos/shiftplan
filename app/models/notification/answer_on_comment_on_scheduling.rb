class Notification::AnswerOnCommentOnScheduling < Notification::CommentOnScheduling

  def tkey
    :answer_on_comment
  end

  def mail_subject
    t(:"mail_subjects.#{tkey}", name: comment.author_name)
  end

  def introductory_text
    t(:"introductory_texts.#{tkey}",
      author_name: comment.author_name,
      employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day),
      quickie: scheduling.quickie)
  end

  def blurb
    t(:"blurbs.#{tkey}", body: truncated_body)
  end
end
