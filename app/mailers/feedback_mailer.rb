class FeedbackMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default to:      'rw@cileos.com'

  def notification(feedback)
    @feedback = feedback
    mail :from => @feedback.user_email, :subject => t(:'feedback.mailer.subject', name: @feedback.user_name)
  end
end
