# inspired by https://github.com/realityforge/rails-no-cache
module Volksplaner::ControllerCaching
  def self.included(controller)
    controller.class_eval do
      extend ClassMethods
    end
  end

  def force_no_cache_filter_method
    # set modify date to current timestamp
    response.headers["Last-Modified"] = CGI::rfc1123_date(Time.zone.now)

    # set expiry to back in the past (makes us a bad candidate for caching)
    response.headers["Expires"] = "0"

    # HTTP 1.0 (disable caching)
    response.headers["Pragma"] = "no-cache"

    # HTTP 1.1 (disable caching of any kind)
    # HTTP 1.1 'pre-check=0, post-check=0' => (Internet Explorer should always check)
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate, pre-check=0, post-check=0"
  end

  module ClassMethods
    def force_no_cache
      before_filter :force_no_cache_filter_method
    end
  end

end
