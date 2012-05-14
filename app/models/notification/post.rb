class Notification::Post < Notification::Base

  def self.mailer_class
    PostNotificationMailer
  end

  def self.mailer_action
    'new_post'
  end

  def post
    notifiable
  end

  def subject
    I18n.t(:'post_notification_mailer.new_post.subjects.post', name: post.author.name)
  end

  def introductory_text
    I18n.t(:'post_notification_mailer.new_post.introductory_texts.post', name: post.author.name, date: I18n.l(post.published_at, format: :tiny))
  end
end
