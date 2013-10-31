class Notification::AnswerOnCommentOnSchedulingOfEmployee < Notification::CommentOnScheduling
  def mail_subject_options
    { name: comment.author_name }
  end

  def introductory_text_options
    {
      author_name: comment.author_name,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day),
      quickie: scheduling.quickie
    }
  end

  def blurb_options
    { body: truncated_body }
  end
end

