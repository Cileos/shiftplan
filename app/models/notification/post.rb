class Notification::Post < Notification::Base

  def self.mailer_class
    PostNotificationMailer
  end

  def self.mailer_action
    :new_post
  end

  def post
    notifiable
  end

  def mail_subject
    t(:'mail_subjects.post', name: acting_employee.name)
  end

  def acting_employee
    post.author
  end

  def introductory_text
    t(:'introductory_texts.post', name: acting_employee.name, date: I18n.l(post.published_at, format: :tiny))
  end
end
