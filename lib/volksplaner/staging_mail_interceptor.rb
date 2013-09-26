module Volksplaner
  class StagingMailInterceptor
    class << self
      def delivering_email(mail)
        if intercept?(mail)
          mail.headers( 'X-Intercepted-To' => Array(mail.to).join(',') )
          mail.to = 'staging@clockwork.io'
        else
          mail.perform_deliveries = false
          Rails.logger.debug "Interceptor prevented sending mail #{mail.inspect}!"
        end
      end

      def intercept?(mail)
        Array(mail.to).any? do |address|
          address.include?(cileos_mail_suffix) ||
            intercepted_mail_addresses.include?(address)
        end
      end

      def cileos_mail_suffix
        'cileos.com'
      end

      def intercepted_mail_addresses
        [
          'mdz@emtrax.net',
          'support@staging.clockwork.io',
          'support@app.clockwork.io', # for unit test
          'application@clockwork.io'
        ]
      end

    end
  end
end
