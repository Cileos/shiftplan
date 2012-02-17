module ActiveRecord
  class Base
    class << self

      def without_modification
        @@without_modification = true
        transaction do
          yield
          raise Rollback
        end
        @@without_modification = false
      end

      def without_modification?
        @@without_modification ||= false
      end

      # creates (and removes) an eigenclass method to temporary turn of ActiveRecord::Base's timestamping
      # see http://www.hungryfools.com/2007/07/turning-off-activerecord-timestamp.html
      # yes, this is supposed to be threadsafe
      def without_timestamps
        class << self
          def record_timestamps; false; end
        end

        yield

      ensure
        class << self
          remove_method :record_timestamps
        end
      end
    end
  end
end

