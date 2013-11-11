class NotificationCreator
  attr_reader :notifiable
  attr_reader :klass_finder
  attr_reader :recipients_finder

  def initialize(notifiable, opts={})
    @notifiable = notifiable
    @klass_finder = opts.fetch(:klass_finder) { Volksplaner.notification_klass_finder }
    @recipients_finder = opts.fetch(:recipients_finder) { Volksplaner.notification_recipients_finder }
  end

  def create!
    recipients_finder[notifiable].each do |employee|
      notification_class = klass_finder[notifiable, employee]
      notification = notification_class.create!(notifiable: notifiable, employee: employee)
      # TODO: separate persistence of notifications from delivering mails
      # if employee.wants?(notificatuin)
      #   notification.delay.deliver_mail
      # end
    end
  end

end

