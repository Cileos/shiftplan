RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
  config.i18n.default_locale = :en

  config.gem 'gravtastic', :version => '>= 2.1.0'
end