# RFC 2821, the standard that defines how email transport works, lays down the
# email address case sensitivity issue thus:

# The local-part of a mailbox MUST BE treated as case sensitive. Therefore,
# SMTP implementations MUST take care to preserve the case of mailbox
# local-parts. Mailbox domains are not case sensitive. In particular, for some
# hosts the user "smith" is different from the user "Smith". However,
# exploiting the case sensitivity of mailbox local-parts impedes
# interoperability and is discouraged.
#                         ^^^^^^^^^^^
#
# So we downcase the whole email address to be safe

module Volksplaner::CaseInsensitiveEmailAttribute
  def email=(new_email)
    super new_email.present? ? new_email.downcase : new_email
  end
end
