class Notification::Base < ActiveRecord::Base
  self.table_name = 'notifications'

  belongs_to :employee
  belongs_to :notifiable, polymorphic: true

  validates_presence_of :employee

  after_commit :deliver!, on: :create

  def self.mailer_class
    raise NotImplementedError, "must return a your ActionMailer::Base class used to send out mails for notifications of type #{self.class.name}"
  end

  def self.mailer_action
    raise NotImplementedError, "must return the mailer action name of your ActionMailer::Base class used to send out mails for notifications of type #{self.class.name}"
  end

  # for mailer_class: PostNotificationMailer and mailer_action: new_comment, it looks up
  #    post_notification_mailer.new_comment.#{key}
  def t(key, opts={})
    I18n.t(:"#{self.class.mailer_class.name.underscore}.#{self.class.mailer_action}.#{key}", opts)
  end

  protected

  def deliver!
    self.class.mailer_class.send(self.class.mailer_action, self).deliver
    self.sent_at = Time.now
    self.save!
  end
end
