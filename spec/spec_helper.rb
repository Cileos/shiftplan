  ENV["RAILS_ENV"] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

require 'rspec'
require 'rspec/rails'
require 'rspec/fire'
require 'draper/test/rspec_integration'

# Must beloaded early to extend RSpec with RSpecLocale.
# can be removed if we load the whole support dir while preloading
require Rails.root.join('spec/support/locale')

Zonebie.set_random_timezone

RSpec.configure do |config|
  include FactoryGirl::Syntax::Default
  config.include(RSpec::Fire)
  config.include Devise::TestHelpers, :type => :controller
  config.before(:all) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    # Remember current locale to be able to reset the I18n locale to that
    # value after each test case. This prevents side effects between specs
    # that change locale settings.
    @old_locale = I18n.locale
  end

  config.after(:each) do
    DatabaseCleaner.clean
    # Remember current locale to be able to reset the I18n locale to that
    # value after each test case. This prevents side effects between specs
    # that change locale settings.
    I18n.locale = @old_locale
  end

  config.after(:each) do
    Timecop.return # to not confuse the test suite benchmarker ("ran 9001 minutes")
  end

  # useful for debugging without being bombarded with pry prompts:
  # in your example:
  #   $want_pry = true
  #   call_method_that_is_called_a_gazillion.times
  #
  # at thew to be instpected location:
  #   binding.pry if $want_pry
  config.after(:each) do
    # other examples should not open pry
    $want_pry = false
  end

  config.mock_with(:rspec)

  # reload Grammar manually, because the constant QuickieParser is created
  # automatically on Treetop.load
  config.before(:all) do
    Quickie.reload_parser!
  end

  config.extend RSpecLocale

  # use this when testing daylight saving time behaviour
  config.around berlin: true do |example|
    Time.use_zone 'Europe/Berlin', &example
  end
end

# Require supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root/'spec'/'support'/'**'/'*.rb'].each {|f| require f}
