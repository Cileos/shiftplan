class ApplicationController < ActionController::Base
  helper :all
  helper LaterDude::CalendarHelper
  protect_from_forgery

  before_filter :set_object_name
  before_filter :authenticate_user!

  after_filter :aggregate_activities # should probably spawn a thread or something
  after_filter :cleanup_thread

  protected

    def set_object_name
      @object_name ||= params[:controller].split('/').last.singularize
    end

    def current_account
      @current_account ||= begin
        # current_user         || raise("not logged in")
        # current_user.account || raise("current user #{current_user.inspect} does not belong to an account")
        # FIXME should be based on subdomains or something like that ...
        # current_user.accounts.first || raise("current user #{current_user.inspect} does not belong to an account")
        Account.first
      end
    end
    helper_method :current_account

    def aggregate_activities
      Activity.aggregate!
    end

    def cleanup_thread
      Thread.current[:user] = nil
      Thread.current[:activity] = nil
    end
end
