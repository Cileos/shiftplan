class Feedback
  include ActiveAttr::Model
  include Draper::Decoratable

  attribute :name, type: String
  attribute :email, type: String
  attribute :browser, type: String
  attribute :body, type: String

  validates_presence_of :body, :email

  def save
    if valid?
      FeedbackMailer.notification(self).deliver
    end
  end

  def name_or_email
    name.presence || email
  end
end
