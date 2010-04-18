ENV["RAILS_ENV"] ||= "cucumber"

require File.expand_path('../../../config/environment', __FILE__)

require 'steam'
require 'rspec'
require 'rspec/rails'
require 'fileutils'

Steam.config[:html_unit][:java_path] = File.expand_path('../../../vendor/htmlunit-2.6', __FILE__)

# hack - why do we need this?
Shiftplan::Application.routes.draw do |map|
  devise_for :users
end

# hack steam to enable CSV downloads for the time being
# TODO: backport to steam
Steam::Browser:: HtmlUnit::Page.class_eval do
  def body
    if @page.getWebResponse.getContentType == 'text/html'
      @page.asXml
    else
      @page.getContent
    end
  end
end

browser = Steam::Browser.create
browser.set_handler(:confirm) { |page, message| true } # always simulates the ok button

World do
  Steam::Session::Rails.new(browser)
end

at_exit do
  browser.close
  FileUtils.rm(Rails.root.join('public/sprockets.js')) rescue Errno::ENOENT
end

World(Rspec::Matchers)

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

# # How to clean your database when transactions are turned off. See
# # http://github.com/bmabey/database_cleaner for more info.
# if defined?(ActiveRecord::Base)
#   begin
#     require 'database_cleaner'
#     DatabaseCleaner.strategy = :truncation
#   rescue LoadError => ignore_if_database_cleaner_not_present
#   end
# end