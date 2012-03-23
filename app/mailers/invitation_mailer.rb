class InvitationMailer < ActionMailer::Base

  default :from => "info@shiftplan.de"
  default :charset => "UTF-8"

  def invitation(invitation)
    @invitation = invitation
    mail :to => invitation.user.email, :subject => t(:'mailer.invitation.subject')
  end

  def salutation(order)
    t(:"order_mailer.confirmation.header.salutation.#{order.billing_address.title}",
      :first_name => order.billing_address.first_name, :name => order.billing_address.name)
  end
  helper_method :salutation

  def image_filetype(thumb)
    # Call inspect on thumb.path to ensure that the right filetype can be calculated for
    # paths including whitespace. (inspect will surround the path with ")
    `file --mime-type #{thumb.path.inspect}`.chomp.split.last
  end
end
