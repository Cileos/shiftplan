class Notification::UpcomingScheduling < Notification::Base
  def self.mailer_class
    UpcomingSchedulingNotificationMailer
  end

  def self.mailer_action
    :upcoming_scheduling
  end

  def mail_subject
    t(:'mail_subject', scope: tscope,
      account: account.name,
      organization: organization.name,
      plan: plan.name)
  end

  def introductory_text
    t(:'introductory_text', scope: tscope,
      date: I18n.l(scheduling.starts_at.to_date, format: :default_with_week_day),
      quickie: scheduling.quickie)
  end

  def subject
    t(:'subject', scope: tscope)
  end

  def blurb
    t(:'blurb', scope: tscope,
      date: I18n.l(scheduling.starts_at.to_date),
      quickie: scheduling.quickie,
      account: account.name,
      organization: organization.name,
      plan: plan.name)
  end

  def acting_employee
    employee
  end

  def self.with_scheduling_ended
    joins("INNER JOIN schedulings ON schedulings.id = notifications.notifiable_id").
      where("schedulings.ends_at < '#{Time.zone.now}'")
  end

  private

  def scheduling
    notifiable
  end

  def plan
    scheduling.plan
  end

  def organization
    plan.organization
  end

  def account
    organization.account
  end
end
