require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.dirname(__FILE__) + "/../config/spork_prefork"

  require 'rspec'
  require 'draper/test/rspec_integration'

  # Must beloaded early to extend RSpec with RSpecLocale.
  # can be removed if we load the whole support dir while preloading
  require Rails.root.join('spec/support/locale')

  RSpec.configure do |config|
    include FactoryGirl::Syntax::Default
    config.before(:all) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:each) do
      Timecop.return # to not confuse the test suite benchmarker ("ran 9001 minutes")
    end

    config.mock_with(:rspec)

    # reload Grammar manually, because the constant QuickieParser is created
    # automatically on Treetop.load, else spork does not detect modifications
    config.before(:all) do
      Quickie.reload_parser!
    end

    config.extend RSpecLocale
  end
end

Spork.each_run do
  # TODO move this to #prefork when the test suite is stable
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  require 'rspec/rails' # spork rspec --diagnose says: this preloads all helpers
  Dir[Rails.root/'spec'/'support'/'**'/'*.rb'].each {|f| require f}
  FactoryGirl.reload
  I18n.reload!
  load Rails.root/'config'/'routes.rb'
end
