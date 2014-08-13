class Signup
  include ActiveAttr::Model
  include ActiveAttr::TypecastedAttributes
  include ActiveAttr::AttributeDefaults

  attribute :email
  attribute :password
  attribute :password_confirmation

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
  #  2) creates an Setup the user has to go through after confirmation
  def save!
    User.transaction do
      user.save!
      user.create_setup!
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
