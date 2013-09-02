class Notification::UpcomingScheduling < Notification::Base
  def self.mailer_class
    UpcomingSchedulingNotificationMailer
  end

  def self.mailer_action
    :upcoming_scheduling
  end

  def introductory_text
    t(:'introductory_text',
      date: I18n.l(scheduling.starts_at.to_date,
      format: :default_with_week_day), quickie: scheduling.quickie)
  end

  private

  def scheduling
    notifiable
  end
end
