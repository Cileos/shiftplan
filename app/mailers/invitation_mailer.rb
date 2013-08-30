class InvitationMailer < ClockworkMailer

  def invitation(invitation)
    @invitation = invitation
    mail :to => invitation.email, :subject => t(:'mailer.invitation.subject')
  end
end
