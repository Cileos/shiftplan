Shiftplan::Application.configure do
  config.to_prepare do
    [Devise::SessionsController, Devise::ConfirmationsController,
    Devise::PasswordsController, Devise::RegistrationsController,
    Devise::UnlocksController].each { |c| c.layout 'session' }
  end
end
