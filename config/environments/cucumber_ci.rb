Shiftplan::Application.configure do
  config.active_support.deprecation                 = :stderr
  config.cache_classes                              = true
  config.whiny_nils                                 = true
  config.consider_all_requests_local                = true
  config.action_controller.perform_caching          = true
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method              = :test
  config.i18n.default_locale                        = :en
  # config.action_mailer.default_url_options             = { :host => '???' }
end
