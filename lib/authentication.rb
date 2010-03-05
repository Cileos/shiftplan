# stolen and slightly adapted from Thoughtbot's Clearance
module Authentication
  def self.included(controller)
    controller.send(:include, InstanceMethods)

    controller.class_eval do
      helper_method :current_user, :signed_in?, :signed_out?
      hide_action   :current_user, :signed_in?, :signed_out?
    end
  end

  module InstanceMethods
    def current_user
      Thread.current[:user] ||= user_from_cookie
    end

    def current_user=(user)
      Thread.current[:user] = user
    end

    def signed_in?
      !current_user.nil?
    end

    def signed_out?
      !signed_in?
    end

    def authenticate
      deny_access unless signed_in?
    end

    def sign_in(user)
      if user && user.is_a?(User)
        user.remember_me
        cookies[:remember_token] = { :value => user.remember_token, :expires => 1.year.from_now.utc }
        current_user = user
      end
    end

    def sign_out
      cookies.delete(:remember_token)
      current_user = nil
    end

    def deny_access(flash_message = nil)
      store_location
      flash[:error] = flash_message if flash_message
      redirect_to(new_session_url)
    end

    protected

      def user_from_cookie
        User.find_by_remember_token(cookies[:remember_token]) if cookies[:remember_token]
      end

      def store_location
        session[:return_to] = request.request_uri if request.get?
      end

      def redirect_back_or(default)
        redirect_to(return_to || default)
        clear_return_to
      end

      def return_to
        session[:return_to] || params[:return_to]
      end

      def clear_return_to
        session[:return_to] = nil
      end
  end
end
