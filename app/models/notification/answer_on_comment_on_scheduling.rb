class Notification::AnswerOnCommentOnScheduling < Notification::CommentOnScheduling

  def tkey
    :answer_on_comment
  end

  def mail_subject_options
    { name: comment.author_name }
  end

  def introductory_text_options
    {
      author_name: comment.author_name,
      employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day),
      quickie: scheduling.quickie
    }
  end

  def blurb_options
    { body: truncated_body }
  end
end
