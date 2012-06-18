class EmailChange < ActiveRecord::Base
  belongs_to :user
  accepts_nested_attributes_for :user

  validates_presence_of :email, :user_id, :token

  before_validation :set_token, on: :create
  after_create :send_confirmation_mail

  def confirmed?
    confirmed_at.present?
  end

  protected

  def send_confirmation_mail
    EmailChangeMailer.confirmation(self).deliver
    self.confirmation_sent_at = Time.now
    save!
  end

  def set_token
    self.token = Devise.friendly_token
  end
end
