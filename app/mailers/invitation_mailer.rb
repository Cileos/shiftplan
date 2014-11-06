class InvitationMailer < ClockworkMailer

  def invitation(invitation)
    @invitation = invitation
    mail :to => invitation.email, :subject => t_subject('invitation')
  end

  def notification(invitation)
    @invitation = invitation
    mail :to => invitation.inviter.email, :subject => t_subject('notification', employee_name: invitation.employee.name)
  end

  private

  def t_subject(mailname, opts={})
    t("#{mailname}.subject", opts.reverse_merge(scope: 'mailer.invitation') )
  end

end
