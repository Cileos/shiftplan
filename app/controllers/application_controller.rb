class ApplicationController < ActionController::Base
  include Authentication

  helper :all
  protect_from_forgery

  before_filter :set_object_name
  # FIXME - somehow this can't find the session controller?
  # before_filter :authenticate

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
end
