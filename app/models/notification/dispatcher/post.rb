class Notification::Dispatcher::Post < Notification::Dispatcher::Base

  # TODO: implement
  def create_notifications!

  end

  def self.create_notifications_for(post)
    notification_recipients_for(post).each do |employee|
      notification_class = notification_class_for(post, employee)
      notification_class.create!(notifiable: post, employee: employee)
    end
  end

  def self.notification_recipients_for(post)
    post.organization.employees.select {|e| e.user.present? && post.author != e }
  end

  def self.notification_class_for(post, employee)
    Notification::Post
  end
end
