require 'rubygems'
require 'bundler/setup'

require 'combustion'
require 'capybara/rspec'

Combustion.initialize! :action_controller,
                       :action_view,
                       :sprockets

require 'rspec/rails'
require 'capybara/rails'

module RSpecLocaleHelper
  def in_locale(wanted)
    old = nil
    before :each do
      old = I18n.locale
      I18n.locale = wanted
    end

    after :each do
      I18n.locale = old
    end
  end
end


RSpec.configure do |config|
  config.extend RSpecLocaleHelper
  config.backtrace_clean_patterns = [
        /\/lib\d*\/ruby\//,
        /bin\//,
        /gems/,
        /spec\/spec_helper\.rb/,
        /lib\/rspec\/(core|expectations|matchers|mocks)/
    ]
end
