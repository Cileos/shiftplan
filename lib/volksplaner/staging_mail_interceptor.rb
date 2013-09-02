module Volksplaner
  class StagingMailInterceptor
    class << self
      def delivering_email(mail)
        mail.headers( 'X-Intercepted-To' => Array(mail.to).join(',') )
        mail.to = 'develop@clockwork.io'
      end
    end
  end
end
