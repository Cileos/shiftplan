module Capybara
  class Session
    class TimedOut < RuntimeError; end
    ##
    #
    # Retry executing the block until a truthy result is returned or the timeout time is exceeded
    #
    # @param [Integer] timeout   The amount of seconds to retry executing the given block
    #
    # this method was removed in Capybara v2 so adding it back if not already defined
    #
    unless defined?(wait_until)
      def wait_until(time = Capybara.default_wait_time)
        Timeout::timeout time, TimedOut do
          while !yield
            sleep 0.023
          end
        end
      end
    end
  end
end
