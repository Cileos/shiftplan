class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers

  helper :all
  helper LaterDude::CalendarHelper
  protect_from_forgery

  before_filter :set_object_name
  before_filter :authenticate_user!
  before_filter :authorize_user!

  after_filter :aggregate_activities # should probably spawn a thread or something
  around_filter :set_and_cleanup_thread

  protected

    # TODO: use CanCan or something like that
    def authorize_user!
      if user_signed_in?
        unless current_user.member_of?(current_account)
          # raising 403 here for two reasons: firstly, Warden kicks in if we respond with 401, secondly
          # it's better in line with the HTTP spec: 403 should be raised when authentication won't make
          # a difference (this error here happens when a logged-in user tries to access an account they
          # don't have access to)
          render :text => t(:no_auth_for_account), :status => :forbidden
        end
      end
    end

    def set_object_name
      @object_name ||= params[:controller].split('/').last.singularize
    end

    def current_account
      @current_account ||= Account.find_by_subdomain!(request.subdomain)
      # @current_account ||= Account.find_by_subdomain!(params[:account_name])
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
