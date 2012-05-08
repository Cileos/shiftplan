class Feedback
  include ActiveAttr::Model
  include Draper::ModelSupport

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
    return name if name.present?
    email
  end
end
