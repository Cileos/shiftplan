class Notification::Comment < Notification::Base
  def comment
    notifiable
  end

  def acting_employee
    comment.author
  end
end
