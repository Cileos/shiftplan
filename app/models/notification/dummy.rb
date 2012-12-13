# Acts as a simple Notification used in tests and features. It should show a
# non-critical message like "You did something" and should NOT be used in
# production.
class Notification::Dummy < Notification::Base
  def self.mailer_action
    'happen'
  end
  def self.mailer_class
    mock 'DummyNotificationMailer', happen: true
  end

  def acting_employee
    employee
  end

  def subject
    "You did something"
  end

  def introductory_text
    "You did something awesome"
  end
end
