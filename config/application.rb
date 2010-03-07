require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Shiftplan
  class Application < Rails::Application
    config.load_paths += %w(#{Rails.root}/app/observers #{Rails.root}/app/presenters)
    config.time_zone = "Berlin"
    config.i18n.default_locale = :en
    config.filter_parameters += [:password, :password_confirmation]
    config.active_record.observers = [:'activity/resource_observer', :'activity/element_observer']
  end
end


