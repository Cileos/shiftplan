source 'https://rubygems.org'

gem 'rails', '4.1.7'
gem 'pg'


# Assets and related
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier'
gem 'jquery-rails', '~> 2.1.3' # latest 1.7, ember whines about >1.7
gem 'jquery-ui-rails', '~> 2.0.2'

# do not digest robots.txt, favivon.ico etc
gem "non-stupid-digest-assets"


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


group :test do
  gem 'cucumber-rails', "~> 1.4.0", :require => false
  gem 'rspec-rails', '< 3'
  gem 'rspec-fire'
  gem 'launchy'

  # until niklas has admin rights on pickle and merges fixes for finders
  gem "pickle", github: 'tbuehl/pickle'
  gem "timecop"
  gem "email_spec", '~> 1.4.0'

  # TODO for latest chrome-webdriver remove when capybara > 1.1.2 depends on it
  gem 'selenium-webdriver', '~> 2.42.0'
  # until it fetches from the new location: https://github.com/flavorjones/chromedriver-helper/pull/8
  gem 'chromedriver-helper', git: 'git://github.com/mars/chromedriver-helper.git', branch: 'download-via-bucket-xml'

  gem "guard-rspec"
  gem "guard-cucumber"
  gem "guard-bundler"
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
  gem 'rspec-html-matchers'

  gem 'rails-develotest'

  # select a random timezone on every test run
  gem 'zonebie'
end

group :development, :test do
  gem 'pry'
  gem "guard-jasmine"
  # TODO revive js test suite - jasminerice uses deprecated `match` in its routes
  #gem "jasminerice"
  gem 'rb-fsevent', '~> 0.9', :require => false
  gem 'rb-inotify', '~> 0.9', :require => false
  gem 'zeus'
  gem 'pry-doc'
end

group :development do
  # gem 'ruby-debug19' # http://stackoverflow.com/questions/8378277/cannot-use-ruby-debug19-with-1-9-3-p0
  # TODO updaade to capistrano 3
  gem 'capistrano', '<3'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
  gem 'capistrano-flowdock', github: 'flowdock/capistrano-flowdock', branch: 'capistrano-2', require: false
  gem 'notes', :require => false, :git => 'git://github.com/niklas/notes.git'
  gem 'quiet_assets'

  # see http://railscasts.com/episodes/402-better-errors-railspanel
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'

  # semver for script/release
  gem 'semantic'
end

group :production do
  gem 'therubyracer' # to compile our coffeescript
  gem 'exception_notification'
end

gem 'thin' # webrick must die

gem 'coffee-rails'
gem 'bourbon', '~> 3.1'
gem 'devise'
gem 'spectator-validates_email', :require => 'validates_email'
gem 'cancan'
gem 'simple_form'
gem 'chosen-rails' # for making select boxes more userfriendly
gem 'haml-rails'
gem 'inherited_resources'
gem 'draper', '~> 1.3.0'
gem 'factory_girl_rails', '~>4.2.1' # we use this for seeds, too
gem 'treetop' # parse quickies

gem 'active_attr' # SchedulingFilter, need AttributeDefaults

# we will try to gernerate js the old-fashioned way. TODO remove when reimplemented plans in ember
gem 'versatile_rjs', github: 'niklas/versatile_rjs'
gem 'polyglot' # load treetop grammars with #require

gem 'gon' # push variables from rails to js
gem "active_model_serializers"

gem 'RedCloth' # textilize instructions and other texts from locales

gem 'database_cleaner'
# oh noes, niklas wants kaminari
# gem 'will_paginate', '~> 3.0'
gem 'kaminari'
# until merge of https://github.com/elight/acts_as_commentable_with_threading/pull/32
#             or https://github.com/elight/acts_as_commentable_with_threading/pull/52
gem 'acts_as_commentable_with_threading'
gem 'awesome_nested_set', '~> 3.0.0'

gem 'carrierwave'
gem 'mini_magick'
gem 'remotipart'
gem 'gravtastic'
gem 'ember-rails'
# .emblem templates that look like slim which is similar to haml
gem 'emblem-rails'
gem 'ember-source', '1.5.1.1'
gem "ember-data-source", "1.0.0.beta.7"
gem 'ember-rails-flash', git: 'git://github.com/niklas/ember-rails-flash.git'

gem 'nested_form', :github => 'ryanb/nested_form'

gem 'backup', :require => false # just for restore
gem 'friendly_id'
# mitigate BREACH and CRIME https attack
gem 'breach-mitigation-rails'

gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'whenever', :require => false

# feeds, fork for proper DateTime parsing, see https://github.com/rubyredrick/ri_cal/pull/12
gem 'ri_cal', git: 'git://github.com/KonaTeam/ri_cal.git'

gem 'fastercsv'       # not sure if still required
gem 'csv_builder'
# for Unavailability#account_ids array type support
gem 'postgres_ext'

gem 'tutorial', path: 'vendor/engines/tutorial'

# develop & run an ember-cli app from within our rails app. This allows us to
# * share the rails stylesheets to the ember app
# * while still using ember-cli ES6 Modules for development
# * and we want to deploy them separately (TODO check if this works)
gem 'ember-cli-rails'
