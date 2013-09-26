class Notification::Base < ActiveRecord::Base
  self.table_name = 'notifications'

  belongs_to :employee
  belongs_to :notifiable, polymorphic: true

  validates_presence_of :employee

  after_commit :deliver!, on: :create

  def self.mailer_class
    raise NotImplementedError, "must return a your ActionMailer::Base class used to send out mails for notifications of type #{name}"
  end

  def self.mailer_action
    raise NotImplementedError, "must return the mailer action name of your ActionMailer::Base class used to send out mails for notifications of type #{name}"
  end

  def mail_subject
    raise NotImplementedError, "must implement #{self.class.name}#mail_subject containing a short description of what happened"
  end

  def introductory_text
    raise NotImplementedError, "must implement #{self.class.name}#introductory_text containing a longer description of what happened"
  end

  def acting_employee
    raise NotImplementedError, "must implement #{self.class.name}#acting_employee returning the employee who caused the reason for the notification"
  end

  # for mailer_class: PostNotificationMailer and mailer_action: new_comment, it looks up
  #    post_notification_mailer.new_comment.#{key}
  def t(key, opts={})
    I18n.t(:"#{self.class.mailer_class.name.underscore}.#{self.class.mailer_action}.#{key}", opts)
  end

  def self.recent(num=5)
    order('updated_at DESC').limit(num)
  end

  def self.by_notifiable(notifiable)
    where(notifiable_id: notifiable.id).where(notifiable_type: notifiable.class.name)
  end

  def user_locale
    locale = employee.user.try(:locale)
    locale.present? ? locale.to_sym : I18n.default_locale
  end

  protected

  def deliver!
    if employee.user && employee.user.receive_notification_emails
      self.class.mailer_class.public_send(self.class.mailer_action, self).deliver
      touch :sent_at
    end
  end
end
