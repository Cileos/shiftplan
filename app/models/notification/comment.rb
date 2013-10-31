class Notification::Comment < Notification::Base
  def comment
    notifiable
  end

  def acting_employee
    comment.author
  end

  def mail_subject_options
    { name: comment.author_name }
  end

  def subject
    comment.author_name
  end

  def blurb_options
    { body: truncated_body }
  end

  def truncated_body
    comment.body.truncate(30, omission: "...")
  end
end
