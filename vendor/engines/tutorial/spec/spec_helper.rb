require 'rubygems'
require 'bundler/setup'

require 'combustion'
require 'capybara/rspec'

Combustion.initialize! :action_controller,
                       :action_view,
                       :sprockets

require 'rspec/rails'
require 'rspec/fire'
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

  # use this when using Tutorial.define_chapter
  def keep_chapter_conditions
    old = nil
    before :each do
      old = Tutorial::Chapter.conditions.dup
    end

    after :each do
      Tutorial::Chapter.conditions = old
    end
  end
end


RSpec.configure do |config|
  config.extend RSpecLocaleHelper
  config.backtrace_exclusion_patterns = [
        /\/lib\d*\/ruby\//,
        /bin\//,
        /gems/,
        /spec\/spec_helper\.rb/,
        /lib\/rspec\/(core|expectations|matchers|mocks)/
    ]
  config.include(RSpec::Fire)
end
