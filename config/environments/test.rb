Shiftplan::Application.configure do
  config.cache_classes                              = true
  config.whiny_nils                                 = true
  config.consider_all_requests_local                = true
  config.action_controller.perform_caching          = false
  config.action_view.cache_template_loading         = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method              = :test
  config.colorize_logging                           = false
  config.i18n.default_locale                        = :en
  config.action_mailer.default_url_options          = { :host => 'localhost:3000' }
end
