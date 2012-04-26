module ActionController
  module AuthenticateUser
    def self.included(target)
      target.extend(ClassMethods)
      target.send(:include, InstanceMethods)
    end

    module ClassMethods

      def authentication_required(*options)
        before_filter :require_authentication, options
      end

      def no_authentication_required(*options)
        skip_before_filter :require_authentication, options
      end
    end

    module InstanceMethods
      private

      def require_authentication
        %w(sessions registrations confirmations passwords unlocks omniauth_callbacks).each do |c|
          %w(new create show).each do |a|
            return if (controller_name == c) && (action_name == a)
          end
        end

        # If we cannot get the current user store the requested page
        # and send them to the login page.
        if current_user.nil?
          redirect_to new_user_session_url(:return_to => request.path) and false
        end
      end
    end
  end
end

