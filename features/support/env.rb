require 'rubygems'
require 'spork'

Spork.prefork do
  require File.expand_path('../../../config/environment', __FILE__)

  require 'rspec'
  require 'rspec/rails'
  require 'fileutils'

  require 'capybara/rails'
  require 'cucumber/rails'

  require 'email_spec'
  require 'email_spec/cucumber'

  World(RSpec::Matchers)

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css

  require 'database_cleaner'
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.clean_with :truncation

  Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
    DatabaseCleaner.strategy = :truncation, {:except => %w[widgets]}
  end
  
  Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
    DatabaseCleaner.strategy = :transaction
  end
end

Spork.each_run do
  I18n.reload!
  FactoryGirl.reload
end
