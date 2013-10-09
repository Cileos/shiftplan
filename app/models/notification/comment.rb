class Notification::Comment < Notification::Base
  def comment
    notifiable
  end

  def acting_employee
    comment.author
  end

  def subject
    comment.author_name
  end

  def truncated_body
    comment.body.truncate(30, omission: "...")
  end
end
