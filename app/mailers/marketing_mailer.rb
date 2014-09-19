class MarketingMailer < ClockworkMailer
  Address = 'marketing@clockwork.io'

  def user_has_registered(user)
    @user = user
    mail to: Address, subject: "User has registered: #{user.email}"
  end

  def account_was_set_up(account)
    @account = account
    mail to: Address, subject: "Account was set up: #{account.email}"
  end
end
