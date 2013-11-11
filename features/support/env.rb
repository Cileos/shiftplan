ENV["RAILS_ENV"] = "test"
# switch chrome to german for @javascript tests
ENV['LANGUAGE'] = 'de'
ENV['LANG'] = 'de_DE.UTF-8'
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
  World(FactoryGirl::Syntax::Methods)

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css


  require File.dirname(__FILE__) + "/browsers"
  unless ARGV.include?('~@javascript')
    if ENV['CAPYBARA_CHROME'] == 'yes'
      STDERR.puts "will run @javascript tests in chrome"
      BrowserSupport.setup_chrome
    else
      STDERR.puts "will run @javascript tests in firefox"
      BrowserSupport.setup_firefox
    end
  end

  Capybara.server do |app, port|
    require 'rack/handler/webrick'
    Rack::Handler::WEBrick.run(app, :Port => port, :AccessLog => [], :Logger => WEBrick::Log::new(Rails.root.join("log/capybara_test.log").to_s))
  end

  # some people have slow computers, 2s are not enough. CI is slow also
  Capybara.default_wait_time = 8

  DatabaseCleaner.clean_with :truncation

  # Remember current locale to be able to reset the I18n locale to that
  # value after each scenario. This prevents side effects between scenarios
  # that change locale settings.
  Before { @old_locale = I18n.locale }
  After  { I18n.locale = @old_locale }

  Before '@instant_jobs' do
    @old_instance_jobs_setting = Delayed::Worker.delay_jobs
    Delayed::Worker.delay_jobs = false
  end
  After '@instant_jobs' do
    Delayed::Worker.delay_jobs = @old_instance_jobs_setting
  end
end

Spork.each_run do
  DatabaseCleaner.clean_with :truncation
  I18n.backend.reload!
  FactoryGirl.reload
end
