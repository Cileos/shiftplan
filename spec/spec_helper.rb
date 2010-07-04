ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'rspec/rails'

require File.expand_path(File.dirname(__FILE__) + '/blueprints')

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'no_peeping_toms'
ActiveRecord::Observer.disable_observers

Rspec.configure do |c|
  c.before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Sham.reset(:before_all)
  end

  c.before(:each) do
    DatabaseCleaner.start
    Sham.reset(:before_each)
  end

  c.after(:each) do
    DatabaseCleaner.clean
  end

  c.mock_with(:rspec)
end
