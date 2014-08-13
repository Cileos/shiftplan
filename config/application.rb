require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clockwork
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(
      #{config.root}/app/inputs
      #{config.root}/app/validators
      #{config.root}/app/widgets
      #{config.root}/app/services
    )
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Berlin'

    # we want the application to raise an error if an invalid locale is passed
    config.i18n.enforce_available_locales = true

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.paths << Rails.root.join("vendor", "assets", "fonts")

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.generators do |g|
      g.orm :active_record
      g.test_framework :rspec
      g.javascript_engine :coffee
      g.template_engine :haml
      g.controller_specs false
      g.view_specs false
    end

    config.ember.variant = :development
    config.handlebars.templates_root = 'templates'
  end
end
