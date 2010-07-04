class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  helper :all
  helper LaterDude::CalendarHelper
  protect_from_forgery

  before_filter :set_object_name
  before_filter :authenticate_user!

  after_filter :aggregate_activities # should probably spawn a thread or something
  around_filter :set_and_cleanup_thread

  protected

    def set_object_name
      @object_name ||= params[:controller].split('/').last.singularize
    end

    def current_account
      @current_account ||= begin
        account   = Account.find_by_subdomain(request.subdomain)
        account ||= Account.first # temporary for testing
      end
    end
    helper_method :current_account

    def aggregate_activities
      Activity.aggregate!
    end

    def set_and_cleanup_thread
      Thread.current[:user] = current_user
      Thread.current[:account] = current_account
      yield
      Thread.current[:user] = nil
      Thread.current[:account] = nil
      Thread.current[:activity] = nil
    end
end
