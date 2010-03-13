Shiftplan::Application.configure do
  config.cache_classes                                 = false
  config.whiny_nils                                    = true
  config.action_controller.consider_all_requests_local = true
  config.action_controller.perform_caching             = false
  config.action_controller.allow_forgery_protection    = false
  config.action_mailer.delivery_method                 = :test
  config.action_mailer.default_url_options             = { :host => 'localhost:3000' }
end
