class InvitationMailer < ActionMailer::Base
  default from: "Clockwork <no-reply@#{Volksplaner.hostname}>"
  default :charset => "UTF-8"

  def invitation(invitation)
    @invitation = invitation
    mail :to => invitation.email, :subject => t(:'mailer.invitation.subject')
  end
end
