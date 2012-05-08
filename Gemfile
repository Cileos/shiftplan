source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'uglifier', '>= 1.2.3'
  gem 'jquery-rails'
  gem 'bootstrap-sass', '~> 2.0.2'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


group :test do
  gem 'cucumber-rails', "~> 1.2.1", :require => false
  gem 'rspec-rails', "~> 2.8.1"
  gem 'launchy'
  gem "pickle"
  gem "timecop"
  gem "email_spec"

  # TODO for latest chrome-webdriver remove when capybara > 1.1.2 depends on it
  gem 'selenium-webdriver', '~> 2.19.0'

  gem "spork", "1.0.0rc2"
  gem "guard-rspec", "~> 0.6.0"
  gem "guard-cucumber", "~> 0.7.5"
  gem "guard-spork", "~> 0.5.2"
  gem "guard-bundler", "~> 0.1.3"
  gem "libnotify", :require => false

  # gem 'ruby-debug19' # http://stackoverflow.com/questions/8378277/cannot-use-ruby-debug19-with-1-9-3-p0
  gem "kopflos", :git => 'git://github.com/niklas/kopflos.git'

  gem 'simplecov', :require => false
end

group :development, :test do
  gem 'pry'
  gem "guard-jasmine"
  gem "jasminerice"
end

group :development do
  # gem 'ruby-debug19' # http://stackoverflow.com/questions/8378277/cannot-use-ruby-debug19-with-1-9-3-p0
  gem 'capistrano'
  gem 'notes', :require => false, :git => 'git://github.com/v0n/notes.git'
end

group :production do
  gem 'therubyracer' # to compile our coffeescript
end

gem 'coffee-rails', '~> 3.2.2'
gem 'compass-rails'
gem 'devise'
gem 'cancan'
gem 'simple_form', '~> 2.0.0'
gem 'haml-rails'
gem 'inherited_resources'
gem 'draper'
gem 'factory_girl_rails' # we use this for seeds, too
gem 'treetop' # parse quickies

gem 'active_attr', '~> 0.5.0.alpha2' # SchedulingFilter, need AttributeDefaults

# we will try to gernerate js the old-fashioned way
gem 'versatile_rjs', :git => 'git://github.com/niklas/versatile_rjs.git'
gem 'polyglot' # load treetop grammars with #require

gem 'gon' # push variables from rails to js

gem 'RedCloth' # textilize instructions and other texts from locales


gem 'sprockets-urlrewriter'
gem 'database_cleaner'
gem 'will_paginate', '~> 3.0'
gem 'acts_as_commentable_with_threading', '~> 1.1.2'
