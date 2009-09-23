class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  before_filter :set_object_name

  protected

    def set_object_name
      @object_name ||= params[:controller].split('/').last.singularize
    end
end
