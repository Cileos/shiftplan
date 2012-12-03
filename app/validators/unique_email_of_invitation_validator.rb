# The email address of an Invitation must be unique within the Account, but it has no foreign key to the Account.
#
# WARNING: does not ignore the invite itself, so only works on :create
class UniqueEmailOfInvitationValidator < ActiveModel::Validator

  def validate(invite)
    if (email = invite.email).present? && (account = invite.account).present?

      if account.users.where(email: email).count > 0
        invite.errors[:email] << I18n.t('activerecord.errors.models.invitation.other_user_has_email')
      end

      if account.invitations.where(email: email).count > 0
        invite.errors[:email] << I18n.t('activerecord.errors.models.invitation.other_invitation_has_email')
      end

    end
  end

end

