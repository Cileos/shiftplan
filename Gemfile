source 'http://rubygems.org'

gem 'rails', '3.2.2'
gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'uglifier', '>= 1.2.3'
  gem 'jquery-rails', '~> 2.1.3' # latest 1.7, ember whines about >1.7
  gem 'jquery-ui-rails'
  # until merge of https://github.com/thomas-mcdonald/bootstrap-sass/pull/170
  gem 'bootstrap-sass', '~> 2.0.4', git: "git://github.com/niklas/bootstrap-sass.git"
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


group :test do
  gem 'cucumber-rails', "~> 1.2.1", :require => false
  gem 'rspec-rails', "~> 2.11.o"
  gem 'launchy'
  gem "pickle"
  gem "timecop"
  gem "email_spec"

  # TODO for latest chrome-webdriver remove when capybara > 1.1.2 depends on it
  gem 'selenium-webdriver', '~> 2.26.0'
  gem 'chromedriver-helper'

  gem "spork", "1.0.0rc2"
  gem "guard-rspec", "~> 1.1.0"
  gem "guard-cucumber", "~> 1.2.0"
  gem "guard-spork", "~> 1.1.0"
  gem "guard-bundler", "~> 1.0.0"
  gem "libnotify", :require => false

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
  gem 'notes', :require => false, :git => 'git://github.com/v0n/notes.git'
end

group :production do
  gem 'therubyracer' # to compile our coffeescript
  gem 'exception_notification'
end

gem 'thin' # webrick must die

gem 'coffee-rails', '~> 3.2.2'
gem 'bourbon'
gem 'devise'
gem 'cancan'
gem 'simple_form', '~> 2.0.0'
gem 'haml-rails'
gem 'inherited_resources'
gem 'draper', '~> 0.14.0'
gem 'factory_girl_rails', '~>3.5.0' # we use this for seeds, too
gem 'treetop' # parse quickies

gem 'active_attr', '~> 0.5.0.alpha2' # SchedulingFilter, need AttributeDefaults

# we will try to gernerate js the old-fashioned way. TODO extract tas rajesh
gem 'versatile_rjs', :git => 'git://github.com/condor/versatile_rjs.git'
gem 'polyglot' # load treetop grammars with #require

gem 'gon' # push variables from rails to js
gem "active_model_serializers", :git => "git://github.com/josevalim/active_model_serializers.git"

gem 'RedCloth' # textilize instructions and other texts from locales

gem 'database_cleaner'
# oh noes, niklas wants kaminari
# gem 'will_paginate', '~> 3.0'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'acts_as_commentable_with_threading', '~> 1.1.2'
gem 'carrierwave'
gem 'mini_magick'
gem 'remotipart'
gem 'gravtastic'
gem 'ember-rails'
gem 'ember-rails-flash', git: 'git://github.com/niklas/ember-rails-flash.git', ref: '6391429'
