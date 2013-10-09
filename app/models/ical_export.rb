class IcalExport < Struct.new(:user)

  delegate :email,
           :private_token,
           to: :user

  def active?
    user.private_token.present?
  end

  def save
    user.private_token = Volksplaner.token_generator_20.call
    user.save!
  end

  def destroy
    user.private_token = nil
    user.save!
  end

end
