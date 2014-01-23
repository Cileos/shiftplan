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
                        :last_name

  validates_format_of :account_name, with: Volksplaner::NameRegEx
  validates_format_of :organization_name, with: Volksplaner::NameRegEx
  validates_format_of :first_name, :last_name, with: Volksplaner::HumanNameRegEx
  validates :email, :email => true

  validates_each :user do |signup, _, user|
    unless user.valid?
      # copy errors from user to signup
      user.errors.messages.each do |field, msgs|
        msgs.each do |msg|
          signup.errors.add field, msg
        end
      end
    end
  end

  # Sets up the basic structure:
  #  1) creates the user, sending out confirmation mail
  #  2) creates an Account
  #  3) creates an Organization (and sets it up)
  #  4) creates an Employee
  #      a) being owner of the Account
  #      b) and member of the Organization
  def save!
    # create user, account, organization, and first employee
    User.transaction do
      user.save!

      Account.create!(name: account_name).tap do |account|
        organization = Organization.create!(name: organization_name, account: account)
        organization.setup # creates the organization's blog
        e = user.employees.create! do |e|
          e.first_name  = first_name
          e.last_name   = last_name
          e.account     = account
        end
        # make the owner member of the first organization
        e.memberships.create!(organization: organization)
        account.owner_id = e.id
        account.save!
      end
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
