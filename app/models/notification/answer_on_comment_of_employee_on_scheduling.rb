class Notification::AnswerOnCommentOfEmployeeOnScheduling < Notification::CommentOnScheduling

  def tkey
    :answer_on_comment_of_employee
  end

  def mail_subject
    t(:'mail_subject', scope: tscope, name: comment.author_name)
  end

  def introductory_text
    t(:'introductory_text', scope: tscope,
      author_name: comment.author_name,
      employee_name: scheduling.employee.name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day),
      quickie: scheduling.quickie)
  end

  def blurb
    t(:'blurb', scope: tscope,
      body: truncated_body)
  end
end

