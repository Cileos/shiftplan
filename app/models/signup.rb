class Signup
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults

  attribute :account_name
  attribute :organization_name
  attribute :first_name
  attribute :last_name
  attribute :email
  attribute :password
  attribute :password_confirmation

  validates_presence_of :organization_name,
                        :account_name,
                        :first_name,
                        :last_name,
                        :email

  validates_format_of :account_name, with: Volksplaner::NameRegEx
  validates_format_of :organization_name, with: Volksplaner::NameRegEx
  validates_format_of :first_name, :last_name, with: Volksplaner::HumanNameRegEx
  validates :email, :email => true

  def save!
    # create user, account, organization, and first employee
    User.transaction do
      user.save!
    end
  end

  def persisted?
    false
  end

  def user
    @user ||= User.new email: email,
                       password: password,
                       password_confirmation: password_confirmation
  end
end
