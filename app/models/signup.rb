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
  end

  def persisted?
    false
  end
end
