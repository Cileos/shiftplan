source 'http://gemcutter.org'

# gem "rails", :git => "git://github.com/rails/rails.git"
gem "rails",      '>=3.0.0beta1'
gem 'rack'
gem 'gravtastic', '>= 2.1.0'
gem 'later_dude', '>= 0.3.1'
gem 'minimal'
gem 'warden'
gem 'devise',     '>= 1.1.pre'

#needed for heroku
#use locally "bundle install --without production"
group :production do
	gem 'pg'
	gem 'thin'
end

group :test do
	gem 'mysql',      '>= 2.7'
	gem 'ruby-debug'
	gem 'machinist'
	gem 'faker'
	gem 'cucumber'
	gem 'steam'
	gem 'rspec',       '>= 2.0.0.a5'
	gem 'rspec-rails', '>= 2.0.0.a6'
	gem 'rcov'
	gem 'launchy'
	gem 'no_peeping_toms'
end

#group :test includes all needed gems for test and cucumber
#heroku just excludes :test and :development
#group :cucumber do
#	gem 'ruby-debug'
#	gem 'cucumber'
#	gem 'steam'
#	gem 'rspec',       '>= 2.0.0.a5'
#	gem 'rspec-rails', '>= 2.0.0.a6'
#	gem 'launchy'
#end

#group :cucumber_development do
#	gem 'ruby-debug'
#end

group :development do
	gem 'mysql',      '>= 2.7'
	gem 'ruby-debug'
end
