require 'action_controller/authenticate_user'
ActionController::Base.send :include, ActionController::AuthenticateUser
