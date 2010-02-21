ENV["RAILS_ENV"] ||= "cucumber"

require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

require 'steam'
require 'rspec'
require 'rspec/rails'

browser = Steam::Browser.create # (:daemon => true)
World do
  Steam::Session::Rails.new(browser)
end

World(Rspec::Matchers)

at_exit do
  browser.close
end

Dir[Rails.root + 'app/models/**/*.rb'].each { |f| require f }
Before do
  ActiveRecord::Base.send(:subclasses).each do |model|
    connection = model.connection
    if model.table_exists?
      if connection.instance_variable_get(:@config)[:adapter] == 'mysql'
        connection.execute("TRUNCATE #{model.table_name}")
      else
        connection.execute("DELETE FROM #{model.table_name}")
      end
    end
  end
end
