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
Steam::Browser::HtmlUnit::Page.class_eval do
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

World { Steam::Session::Rails.new(browser) }
World(Rspec::Matchers)

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
Before { DatabaseCleaner.clean }

at_exit do
  browser.close
  FileUtils.rm(Rails.root.join('public/sprockets.js')) rescue Errno::ENOENT
end
