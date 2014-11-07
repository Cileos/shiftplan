class EmailChange < ActiveRecord::Base
  # email gets validated in User due to :before_save :create_email_change
  belongs_to :user
  validates_presence_of :email, :user_id, :token

  include Volksplaner::CaseInsensitiveEmailAttribute

  before_validation :set_token, on: :create

  def confirmed?
    confirmed_at.present?
  end

  def send_confirmation_mail
    EmailChangeMailer.confirmation(self).deliver
    touch(:confirmation_sent_at)
  end

  protected

  def set_token
    self.token = Devise.friendly_token
  end
end
