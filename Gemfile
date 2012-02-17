source 'http://rubygems.org'

gem 'rails', '3.2.1'
gem 'pg'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'uglifier', '>= 1.2.3'
  gem 'jquery-rails'
  gem 'bootstrap-sass', '~> 2.0.0'
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
  gem 'cucumber-rails', "~> 1.2.1"
  gem 'rspec-rails', "~> 2.8.1"
  gem 'launchy'
  gem "pickle"
  gem "timecop"
  gem 'database_cleaner'
  gem "email_spec"

  gem "spork", "1.0.0rc2"
  gem "guard-rspec", "~> 0.6.0"
  gem "guard-cucumber", "~> 0.7.5"
  gem "guard-spork", "~> 0.5.2"
  gem "guard-bundler", "~> 0.1.3"
  gem "libnotify"

  gem 'pry'
  # gem 'ruby-debug19' # http://stackoverflow.com/questions/8378277/cannot-use-ruby-debug19-with-1-9-3-p0
  gem "kopflos", :git => 'git://github.com/niklas/kopflos.git'
  gem 'plymouth'
end

group :development do
  gem 'pry'
  # gem 'ruby-debug19' # http://stackoverflow.com/questions/8378277/cannot-use-ruby-debug19-with-1-9-3-p0
  gem 'capistrano'
end

group :production do
  gem 'therubyracer' # to compile our coffeescript
end

gem 'coffee-rails', '~> 3.2.2'
gem 'devise'
gem 'simple_form', git: "git://github.com/plataformatec/simple_form.git", ref: "v2.0.0.rc"
gem 'haml-rails'
gem 'inherited_resources'
gem 'draper'
gem 'factory_girl_rails' # we use this for seeds, too
gem 'treetop' # parse quickies
gem 'polyglot' # load treetop grammars with #require

gem 'active_attr', '~> 0.5.0.alpha2' # SchedulingFilter, need AttributeDefaults
