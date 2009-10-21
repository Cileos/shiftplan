class ApplicationController < ActionController::Base
  include Authentication

  helper :all
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  before_filter :set_object_name
  before_filter :authenticate

  protected

    def set_object_name
      @object_name ||= params[:controller].split('/').last.singularize
    end

    def current_account
      @current_account ||= current_user.try(:account)
    end
end
