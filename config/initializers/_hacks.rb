# Keep versatile_rjs alive
#

module ActiveSupport
  module JSON
    # Deprecated: A string that returns itself as its JSON-encoded form.
    class Variable < String
      def initialize(*args)
        if false # we know we must destroy RJS
          message = 'ActiveSupport::JSON::Variable is deprecated and was removed in Rails 4.1. ' \
                    'We still need to for versatile_rjs to work'
          ActiveSupport::Deprecation.warn message
        end
        super
      end

      def as_json(options = nil) self end #:nodoc:
      def encode_json(encoder) self end #:nodoc:
    end
  end
end
