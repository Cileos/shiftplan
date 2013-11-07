class Notification::Dispatcher::Post < Notification::Dispatcher::Base

  def create_notifications!
    recipients.each do |employee|
      Notification::Post.create!(notifiable: post, employee: employee)
    end
  end

  private

  def post
    origin
  end

end
