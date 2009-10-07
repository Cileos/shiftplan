$: << File.expand_path(File.dirname(__FILE__) + "/../../../lib")

require 'rubygems'
# require 'cucumber/formatter/unicode'
# require 'cucumber/rails/rspec'

ENV["RAILS_ENV"] ||= "cucumber"

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
ActiveRecord::Base.establish_connection(:test)

# ActionController::Base.allow_rescue = false

require 'steam'
  
World do
  root   = File.expand_path(RAILS_ROOT + '/public')
  static = Steam::Connection::Static.new(:root => root)
  rails  = Steam::Connection::Rails.new

  connection = Rack::Cascade.new([static, rails])
  browser    = Steam::Browser::HtmlUnit.new(connection)
  @session   = Steam::Session::Rails.new(browser)
end

Before do
  ActiveRecord::Base.send(:subclasses).each do |model| 
    model.connection.execute("TRUNCATE #{model.table_name}")
    # model.delete_all rescue next
  end
end
