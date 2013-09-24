class IcalExport < Struct.new(:user)

  def active?
    user.private_token.present?
  end

  def save
    user.private_token = Volksplaner.token_generator_20.call
    user.save!
  end

end
