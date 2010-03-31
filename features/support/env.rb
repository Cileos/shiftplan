ENV["RAILS_ENV"] ||= "cucumber"

require File.expand_path('../../../config/environment', __FILE__)

require 'steam'
require 'rspec'
require 'rspec/rails'

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

browser = Steam::Browser.create # (:daemon => true)
World do
  Steam::Session::Rails.new(browser)
end

at_exit do
  browser.close
end

World(Rspec::Matchers)

# don't like this ... better ideas?
# ensure logout after each scenario
After do
  visit '/users/sign_out'
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
