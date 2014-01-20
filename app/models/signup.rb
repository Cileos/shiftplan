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

  def save!
    # create user, account, organization, and first employee
  end

  def persisted?
    false
  end
end
