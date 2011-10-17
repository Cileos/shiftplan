Spork.prefork do
  require File.expand_path('../../../config/environment', __FILE__)

  require 'rspec'
  require 'rspec/rails'
  require 'fileutils'

  World(RSpec::Matchers)

  require 'database_cleaner'
  DatabaseCleaner.strategy = :truncation
  Before { DatabaseCleaner.clean }
end

Spork.each_run do
  I18n.reload!
  FactoryGirl.reload
end
