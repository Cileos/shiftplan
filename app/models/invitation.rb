class Invitation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :employee
  belongs_to :user
  belongs_to :inviter, class_name: 'Employee'
  delegate :account, to: :organization

  validates_presence_of :organization_id, :email
  validates_uniqueness_of :email, scope: :organization_id
  validates :email, :email => true, :unless => Proc.new{ |inv| inv.email.blank? }
  validates_with UniqueEmailOfInvitationValidator, on: :create

  after_save :associate_employee_with_user

  accepts_nested_attributes_for :user

  include Volksplaner::CaseInsensitiveEmailAttribute

  def accepted?
    accepted_at.present?
  end

  def accept!
    update_attributes!(accepted_at: Time.zone.now)
    send_notification
  end

  def send_invitation
    set_token
    InvitationMailer.invitation(self).deliver
    self.sent_at = Time.zone.now
    save!
  end

  # OPTIMIZE delive rasynchronically
  def send_notification
    InvitationMailer.notification(self).deliver
  end

  protected

  def set_token
    self.token = Devise.friendly_token
  end

  def associate_employee_with_user
    if user && !employee.user
      employee.user = user
      employee.unavailabilities.where(user_id: nil).update_all(user_id: user.id)
      employee.save!
    end
  end
end

InvitationDecorator
