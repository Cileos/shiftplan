class FeedbackMailer < ActionMailer::Base
  default charset: 'UTF-8'
  default to:      ['rw@cileos.com', 'nh@cileos.com', 'ft@cileos.com', 'mdz@emtrax.net']

  def notification(feedback)
    @feedback = feedback
    mail :from => @feedback.email, :subject => t(:'feedback.mailer.subject', name: @feedback.name_or_email)
  end
end
