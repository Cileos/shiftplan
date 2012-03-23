class Invitation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :employee
  belongs_to :user
  belongs_to :inviter, class_name: 'Employee'

  validates_presence_of :token, :sent_at, :organization_id, :employee_id, :user_id

  attr_accessor :email, :password, :password_confirmation

  before_validation :set_token, :set_sent_at, on: :create
  before_validation :set_user, on: :create
  after_create :associate_employee_with_user

  accepts_nested_attributes_for :user

  #validates_uniqueness_of :user_id, scope: [:organization_id]

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

  def set_user
    if user = User.find_by_email(email)
      self.user = user
    else
      # We do not set a password here. The password should be set by the user itself when
      # accepting the invitation. This is why we save the new user without validation.
      user = User.new(:email => email)
      # Do not send a confirmation mail. Accepting the invitation will confirm the user's email.
      user.skip_confirmation!
      user.save(validate: false)
      self.user = user.reload
    end
  end

  def associate_employee_with_user
    employee.user = self.user
    employee.save!
  end
end

InvitationDecorator
