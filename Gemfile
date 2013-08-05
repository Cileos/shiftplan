source 'http://rubygems.org'

gem 'rails', '3.2.12'
gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'uglifier', '>= 1.2.3'
  gem 'jquery-rails', '~> 2.1.3' # latest 1.7, ember whines about >1.7
  gem 'jquery-ui-rails', '~> 2.0.2'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


group :test do
  gem 'cucumber-rails', "~> 1.2.1", :require => false
  gem 'rspec-rails', "~> 2.12.2"
  gem 'launchy'
  gem "pickle"
  gem "timecop"
  gem "email_spec", '~> 1.4.0'

  # TODO for latest chrome-webdriver remove when capybara > 1.1.2 depends on it
  gem 'selenium-webdriver', '~> 2.32.1'
  gem 'chromedriver-helper'

  gem "spork", "1.0.0rc3"
  gem "guard-rspec", "~> 2.4.0"
  gem "guard-cucumber", "~> 1.3.2"
  gem "guard-spork", "~> 1.4.2"
  gem "guard-bundler", "~> 1.0.0"
  gem "libnotify", :require => false
  gem 'rb-fsevent', '~> 0.9.1', :require => false

  # gem 'ruby-debug19' # http://stackoverflow.com/questions/8378277/cannot-use-ruby-debug19-with-1-9-3-p0
  gem "kopflos", :git => 'git://github.com/niklas/kopflos.git'

  gem 'simplecov', :require => false
  gem 'term-ansicolor' # for ScenarioTodo

  gem 'fuubar-cucumber'

  gem 'diff_matcher'

  gem 'ci_reporter', "~> 1.7.3"

  # we send our notifications in after_commit hook, but this normally is not
  # fired in an rSpec test suite with transactionial fixtures
  gem 'test_after_commit'
  gem 'rspec-html-matchers'

  gem 'rails-develotest'
end

group :development, :test do
  gem 'pry'
  gem "guard-jasmine"
  gem "jasminerice"
  gem 'rb-inotify', '~> 0.8.8', :require => false
end

group :development do
  # gem 'ruby-debug19' # http://stackoverflow.com/questions/8378277/cannot-use-ruby-debug19-with-1-9-3-p0
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
  gem 'notes', :require => false, :git => 'git://github.com/niklas/notes.git'
  gem 'quiet_assets'

  # see http://railscasts.com/episodes/402-better-errors-railspanel
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :production do
  gem 'therubyracer' # to compile our coffeescript
  gem 'exception_notification'
end

gem 'thin' # webrick must die

gem 'coffee-rails', '~> 3.2.2'
gem 'bourbon'
gem 'devise'
gem 'spectator-validates_email', :require => 'validates_email'
gem 'cancan'
gem 'simple_form', '~> 2.0.0'
gem 'haml-rails'
gem 'inherited_resources'
gem 'draper', '~> 1.1.0'
gem 'factory_girl_rails', '~>4.2.1' # we use this for seeds, too
gem 'treetop' # parse quickies

gem 'active_attr', '~> 0.5.0.alpha2' # SchedulingFilter, need AttributeDefaults

# we will try to gernerate js the old-fashioned way. TODO extract tas rajesh
gem 'versatile_rjs', :git => 'git://github.com/condor/versatile_rjs.git'
gem 'polyglot' # load treetop grammars with #require

gem 'gon' # push variables from rails to js
gem "active_model_serializers", :git => "git://github.com/rails-api/active_model_serializers.git"

gem 'RedCloth' # textilize instructions and other texts from locales

gem 'database_cleaner'
# oh noes, niklas wants kaminari
# gem 'will_paginate', '~> 3.0'
gem 'kaminari'
gem 'acts_as_commentable_with_threading', '~> 1.1.2'
gem 'carrierwave'
gem 'mini_magick'
gem 'remotipart'
gem 'gravtastic'
gem 'ember-rails', '0.7.0'
gem 'ember-rails-flash', git: 'git://github.com/niklas/ember-rails-flash.git', ref: '6391429'

gem 'strong_parameters', '~> 0.1.6'
gem 'nested_form', :git => 'git@github.com:rwrede/nested_form.git'

# mitigate BREACH and CRIME https attack
gem 'breach-mitigation-rails'
