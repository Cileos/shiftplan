class Notification::Base < ActiveRecord::Base
  self.table_name = 'notifications'

  belongs_to :employee
  belongs_to :notifiable, polymorphic: true

  validates_presence_of :employee

  after_create :deliver!

  def self.mailer_class
    raise NotImplementedError, "must return a your ActionMailer::Base class used to send out mails for notifications of type #{self.class.name}"
  end

  def self.mailer_action
    raise NotImplementedError, "must return the mailer action name of your ActionMailer::Base class used to send out mails for notifications of type #{self.class.name}"
  end

  protected

  def deliver!
    self.class.mailer_class.send(self.class.mailer_action, self).deliver
    self.sent_at = Time.now
    self.save!
  end
end
