class NotificationCreator
  attr_reader :notifiable
  attr_reader :opts

  def initialize(notifiable, opts={})
    @notifiable = notifiable
    @opts = opts
  end

  def create!
    recipients_finder[notifiable].each do |employee|
      notification_class = klass_finder[notifiable, employee]
      notification = notification_class.create!(notifiable: notifiable, employee: employee)
      notification.send_mail
    end
  end

  private

  def klass_finder
    opts.fetch(:klass_finder) { Volksplaner.notification_klass_finder }
  end

  def recipients_finder
    opts.fetch(:recipients_finder) { Volksplaner.notification_recipients_finder }
  end

end

