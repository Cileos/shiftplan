ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'spork'

Spork.prefork do
  # keep devise from preloading User model, see https://gist.github.com/1344547
  require 'rails/application'
  Spork.trap_method(Rails::Application, :reload_routes!)
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path('../../../config/environment', __FILE__)

  require 'rspec'
  require 'rspec/rails'
  require 'fileutils'

  require 'capybara/rails'
  require 'cucumber/rails'

  require 'email_spec'
  require 'email_spec/cucumber'

  require 'factory_girl'

  require 'kopflos/cucumber'

  World(RSpec::Matchers)

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css
   
  if ENV['CAPYBARA_CHROME'] == 'yes'
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end
  end

  Capybara.server do |app, port|
    require 'rack/handler/webrick'
    Rack::Handler::WEBrick.run(app, :Port => port, :AccessLog => [], :Logger => WEBrick::Log::new(Rails.root.join("log/capybara_test.log").to_s))
  end

  # some people have slow computers, 2s are not enough. CI is slow also
  Capybara.default_wait_time = 23

end

Spork.each_run do
  I18n.backend.reload!
  FactoryGirl.reload
end
