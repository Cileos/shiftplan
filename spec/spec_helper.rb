ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

require 'machinist/active_record'
require 'sham'
require File.expand_path(File.dirname(__FILE__) + '/blueprints')

if Account.first
  ActiveRecord::Base.send(:subclasses).each do |model|
    connection = model.connection
    if connection.instance_variable_get(:@config)[:adapter] == 'mysql'
      connection.execute("TRUNCATE #{model.table_name}")
    else
      connection.execute("DELETE FROM #{model.table_name}")
    end
  end
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false

  config.before(:all)  { Sham.reset(:before_all)  }
  config.before(:each) { Sham.reset(:before_each) }
end
