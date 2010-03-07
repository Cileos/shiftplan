source 'http://gemcutter.org'

gem "rails", :git => "git://github.com/rails/rails.git"

gem 'rack'
gem 'mysql',      '>= 2.7'
gem 'gravtastic', '>= 2.1.0'

group :test do
	gem 'ruby-debug'
	gem 'machinist'
	gem 'faker'
	gem 'cucumber'
	gem 'steam'
	gem 'rspec',       '>= 2.0.0.a5'
	gem 'rspec-rails', '>= 2.0.0.a6'
	gem 'launchy'
	gem 'no_peeping_toms'
end

group :cucumber do
	gem 'ruby-debug'
	gem 'cucumber'
	gem 'steam'
	gem 'rspec',       '>= 2.0.0.a5'
	gem 'rspec-rails', '>= 2.0.0.a6'
	gem 'launchy'
end

group :cucumber_development do
	gem 'ruby-debug'
end

group :development do
	gem 'ruby-debug'
end

#gem 'ruby-debug',      :group => [:cucumber, :cucumber_development, :development]
#gem 'machinist',       :group => :test
#gem 'faker',           :group => :test
#gem 'cucumber',        :group => [:cucumber, :test]
#gem 'steam',           :group => [:cucumber, :test]
#gem 'rspec',           '>= 2.0.0.a5', :group => [:cucumber, :test]
#gem 'rspec-rails',     '>= 2.0.0.a6', :group => [:cucumber, :test]
#gem 'launchy',         :group => [:cucumber, :test]
#gem 'no_peeping_toms', :group => :test
