ENV["RAILS_ENV"] ||= "test"

$: << File.expand_path(File.dirname(__FILE__) + "/../../vendor/plugins/steam/lib")
require 'rubygems'
require 'spork'
require 'steam'

Spork.prefork do
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

  # Steam::Browser::HtmlUnit::Drb::Service.daemonize and sleep(0.25)
  World do
    browser = Steam::Browser::HtmlUnit.new # (:drb => true)
    Steam::Session::Rails.new(browser)
  end

  Before do
    ActiveRecord::Base.send(:subclasses).each do |model|
      model.connection.execute("TRUNCATE #{model.table_name}")
    end
  end
end

Spork.each_run do
  ActiveRecord::Base.establish_connection(:test)
end


