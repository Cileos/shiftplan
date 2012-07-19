class FeedbackMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default to: 'support@shiftplan.de'

  def notification(feedback)
    @feedback = feedback
    mail :from => @feedback.email, :subject => t(:'feedback.mailer.subject', name: @feedback.name_or_email)
  end
end
