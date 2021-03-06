class EmailChangeMailer < ClockworkMailer

  def confirmation(email_change)
    @email_change = email_change
    mail :to => email_change.email, :subject => t(:'mailer.email_change.confirmation.subject')
  end
end
