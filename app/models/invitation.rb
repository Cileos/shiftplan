class Invitation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :employee
  belongs_to :user
  belongs_to :inviter, class_name: 'Employee'

  validates_presence_of :token, :sent_at, :organization_id, :employee_id, :email

  before_validation :set_token, :set_sent_at, on: :create
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

  def set_sent_at
    self.sent_at = Time.now
  end

  def associate_employee_with_user
    if user && !employee.user
      employee.user = user
      employee.save!
    end
  end
end

InvitationDecorator
