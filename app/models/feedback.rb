class Feedback
  include ActiveAttr::Model
  include Draper::ModelSupport

  attribute :employee_id, type: Integer
  attribute :user_id, type: Integer
  attribute :email, type: String
  attribute :name, type: String
  attribute :body, type: String

  validates_presence_of :body

  def save
    FeedbackMailer.notification(self).deliver
  end

  def employee
    return nil unless employee_id
    Employee.find_by_id(employee_id)
  end

  def user
    return nil unless user_id
    User.find_by_id(user_id)
  end

  def user_name
    return name if name.present?
    email || user.try(:email) || employee.try(:name)
  end

  def user_email
    email || user.try(:email) || employee.try(:user).try(:email)
  end
end
