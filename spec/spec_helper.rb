require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.dirname(__FILE__) + "/../config/spork_prefork"

  require 'rspec/rails'


  RSpec.configure do |config|
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

    config.mock_with(:rspec)
  end
  require 'plymouth'
end

Spork.each_run do
  # TODO move this to #prefork when the test suite is stable
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root/'spec'/'support'/'**'/'*.rb'].each {|f| require f}
  FactoryGirl.reload
  I18n.reload!
  load Rails.root/'config'/'routes.rb'
end
