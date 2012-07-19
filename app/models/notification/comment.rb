class Notification::Comment < Notification::Base
  def comment
    notifiable
  end
end
