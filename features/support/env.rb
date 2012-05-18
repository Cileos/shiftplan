ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'spork'

Spork.prefork do
  require File.dirname(__FILE__) + "/../../config/spork_prefork"

  require 'rspec'
  #require 'rspec/rails'
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
    STDERR.puts "will run @javascript tests in chrome"
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome, :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate])
    end
  else
    STDERR.puts "will run @javascript tests in default browser (probably firefox)"
  end

  Capybara.server do |app, port|
    require 'rack/handler/webrick'
    Rack::Handler::WEBrick.run(app, :Port => port, :AccessLog => [], :Logger => WEBrick::Log::new(Rails.root.join("log/capybara_test.log").to_s))
  end

  # some people have slow computers, 2s are not enough. CI is slow also
  Capybara.default_wait_time = 23

  DatabaseCleaner.clean_with :truncation
end

Spork.each_run do
  DatabaseCleaner.clean_with :truncation
  I18n.backend.reload!
  FactoryGirl.reload
end
