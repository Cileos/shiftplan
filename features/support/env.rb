ENV["RAILS_ENV"] ||= "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../../vendor/plugins/steam/lib")
require 'rubygems'
# require 'spork'
require 'steam'

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

# Steam::Browser::HtmlUnit::Drb::Service.daemonize and sleep(0.25)
browser = Steam::Browser::HtmlUnit.new #(:drb => true)
World do
  Steam::Session::Rails.new(browser)
end

Before do
  ActiveRecord::Base.send(:subclasses).each do |model|
    connection = model.connection
    if connection.instance_variable_get(:@config)[:adapter] == 'mysql'
      connection.execute("TRUNCATE #{model.table_name}")
    else
      connection.execute("DELETE FROM #{model.table_name}")
    end
  end
end

# Spork.prefork do
# end
# 
# Spork.each_run do
#   ActiveRecord::Base.establish_connection(:test)
# end


