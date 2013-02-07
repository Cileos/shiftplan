class EmailChange < ActiveRecord::Base
  # email gets validated in User due to :before_save :create_email_change
  belongs_to :user
  validates_presence_of :email, :user_id, :token

  attr_accessible :confirmed_at,
                  :email

  before_validation :set_token, on: :create
  after_commit :send_confirmation_mail, on: :create

  def confirmed?
    confirmed_at.present?
  end

  protected

  def send_confirmation_mail
    EmailChangeMailer.confirmation(self).deliver
    touch(:confirmation_sent_at)
  end

  def set_token
    self.token = Devise.friendly_token
  end
end
