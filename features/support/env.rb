ENV["RAILS_ENV"] ||= "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")
require 'rubygems'
# require 'spork'
# require 'cucumber/formatter/unicode'
# require 'cucumber/rails/rspec'

# ActionController::Base.allow_rescue = false

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'steam'

browser = Steam::Browser::HtmlUnit.new #(connection)
# root   = File.expand_path(RAILS_ROOT + '/public')
# static = Connection::Static.new(:root => root)
# rails  = Connection::Rails.new
# connection = Rack::Cascade.new([static, rails])

World do
  @session = Steam::Session::Rails.new(browser)
end

Before do
  ActiveRecord::Base.send(:subclasses).each do |model|
    model.connection.execute("TRUNCATE #{model.table_name}")
  end
end

# Spork.prefork do
# end
# 
# Spork.each_run do
#   ActiveRecord::Base.establish_connection(:test)
# end
# 
# 
