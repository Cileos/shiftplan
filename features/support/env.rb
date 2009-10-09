ENV["RAILS_ENV"] ||= "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")
require 'rubygems'
# require 'spork'
# require 'cucumber/formatter/unicode'
# require 'cucumber/rails/rspec'

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'steam'

ActiveRecord::Base.establish_connection(:test)
# ActionController::Base.allow_rescue = false

World do
  include Steam

  # root   = File.expand_path(RAILS_ROOT + '/public')
  # static = Connection::Static.new(:root => root)
  # rails  = Connection::Rails.new
  # connection = Rack::Cascade.new([static, rails])

  browser    = Browser::HtmlUnit.new #(connection)
  @session   = Session::Rails.new(browser)
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
# end


