require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Shiftplan
  class Application < Rails::Application
    config.load_paths += %w(#{Rails.root}/app/observers #{Rails.root}/app/views)
    config.time_zone = "Berlin"
    config.i18n.default_locale = :de
    config.filter_parameters += [:password, :password_confirmation]
    config.active_record.observers = [:'activity/resource_observer', :'activity/element_observer']

    config.session_store :cookie_store, :key => '_shiftplan_session'
    config.cookie_secret = 'd85737ffefa5b429be2d8ee838b853621a8bfd724f0b7a0278517602eae830de8b1149397df5d50a84142f4df41e93e106f44fc30f5b67fec70c1b678a0baf32'
  end
end
