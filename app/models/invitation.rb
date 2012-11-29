class Invitation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :employee
  belongs_to :user
  belongs_to :inviter, class_name: 'Employee'
  belongs_to :account

  validates_presence_of :token, :organization_id, :employee_id, :email, :account_id
  validates_uniqueness_of :email, scope: :account_id

  before_validation :set_token, on: :create
  before_validation :set_account
  after_save :associate_employee_with_user

  accepts_nested_attributes_for :user

  def accepted?
    accepted_at.present?
  end

  def send_email
    InvitationMailer.invitation(self).deliver
    self.sent_at = Time.now
    save!
  end

  protected

  def set_token
    self.token = Devise.friendly_token
  end

  def set_account
    self.account = organization.account
  end

  def associate_employee_with_user
    if user && !employee.user
      employee.user = user
      employee.save!
    end
  end
end

InvitationDecorator
