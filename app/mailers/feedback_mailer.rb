class FeedbackMailer < ClockworkMailer
  default to: "support@clockwork.io"

  def notification(feedback)
    @feedback = feedback
    mail :from => feedback.email,
         :subject => t(:'feedback.mailer.subject', name: feedback.name_or_email),
         :reply_to => feedback.email
  end
end
