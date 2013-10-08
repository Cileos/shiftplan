class Notification::Base < ActiveRecord::Base
  self.table_name = 'notifications'

  belongs_to :employee
  belongs_to :notifiable, polymorphic: true

  validates_presence_of :employee

  after_commit :deliver!, on: :create
  after_create :increase_notifications_count_on_user

  def self.default_sorting
    order('created_at desc')
  end

  def self.unread
    where(read_at: nil)
  end

  def self.for_hub
    unread.default_sorting.limit(10)
  end

  def self.for_dashboard
    default_sorting.limit(15)
  end

  def translation_key
    self.class.translation_key
  end
  alias_method :tkey, :translation_key

  def self.translation_key
    name.split('::').last.underscore.to_sym
  end

  def self.decorator_class
    NotificationDecorator
  end

  def self.mailer_class
    raise NotImplementedError, "must return a your ActionMailer::Base class used to send out mails for notifications of type #{name}"
  end

  def self.mailer_action
    raise NotImplementedError, "must return the mailer action name of your ActionMailer::Base class used to send out mails for notifications of type #{name}"
  end

  def mail_subject
    t(:"mail_subjects.#{tkey}",
      name: acting_employee.name)
  end

  def subject
    raise NotImplementedError, "must implement #{self.class.name}#subject containing a short text of what happened"
  end

  def blurb
    raise NotImplementedError, "must implement #{self.class.name}#blurb containing a short description of what happened"
  end

  def introductory_text
    raise NotImplementedError, "must implement #{self.class.name}#introductory_text containing a longer description of what happened"
  end

  def acting_employee
    raise NotImplementedError, "must implement #{self.class.name}#acting_employee returning the employee who caused the reason for the notification"
  end

  def t(key, opts={})
    I18n.t(:"notifications.#{key}", opts)
  end

  def self.recent(num=5)
    order('updated_at DESC').limit(num)
  end

  def self.by_notifiable(notifiable)
    where(notifiable_id: notifiable.id).where(notifiable_type: notifiable.class.name)
  end

  def self.not_upcoming
    where("type != 'Notification::UpcomingScheduling'")
  end

  def self.older_than(interval)
    raise ArgumentError unless interval =~ /\A\d+ [a-z]+\z/
    where("#{table_name}.created_at < TIMESTAMP :now - INTERVAL '#{interval}'", now: Time.zone.now)
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

  private

  def increase_notifications_count_on_user
    if u = employee.user
      u.new_notifications_count += 1
      u.save!
    end
  end
end
