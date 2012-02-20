class WelcomeController < ApplicationController
  skip_authorization_check only: :landing

  def landing
  end

  def dashboard
    authorize! :dashboard, current_user
  end

end
