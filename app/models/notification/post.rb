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

  def introductory_text
    t(:'introductory_text', scope: tscope,
      name: acting_employee.name,
      date: I18n.l(post.published_at, format: :tiny))
  end

  def subject
    acting_employee.name
  end

  def blurb
    t(:'blurb', scope: tscope,
      title: truncated_title,
      body: truncated_body)
  end

  def acting_employee
    post.author
  end

  private

  def truncated_title
    post.title.truncate(25, omission: "...")
  end

  def truncated_body
    post.body.truncate(30, omission: "...")
  end
end
