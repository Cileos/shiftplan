source 'http://gemcutter.org'

# gem "rails", :git => "git://github.com/rails/rails.git"
gem "rails",      '>=3.0.0beta1'
gem 'rack'
gem 'gravtastic', '>= 2.1.0'
gem 'later_dude', '>= 0.3.1'
gem 'minimal'
gem 'warden'
gem 'devise',     '>= 1.1.pre'
gem 'rspec',       '>= 2.0.0.a5'
gem 'rspec-rails', '>= 2.0.0.a6'
gem 'cucumber'

#needed for heroku
#use locally "bundle install --without production"
group :production do
	gem 'pg'
	gem 'thin'
end
