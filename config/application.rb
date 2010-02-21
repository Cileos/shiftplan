require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module Shiftplan
  class Application < Rails::Application
    config.load_paths += ["#{Rails.root}/app/presenters"]
    config.i18n.default_locale = :en
    config.filter_parameters += [:password, :password_confirmation]
  end
end
