Shiftplan::Application.configure do
  config.active_support.deprecation        = :log
  config.cache_classes                     = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # config.action_mailer.default_url_options = { :host => '???' }
end
