$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "tutorial/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "tutorial"
  s.version     = Tutorial::VERSION
  s.authors     = ["Niklas Hofer"]
  s.email       = ["nh@cileos.com"]
  s.homepage    = "http://clockwork.io"
  s.summary     = "The Tutorial for Clockwork"
  s.description = "Highly experimental approach to an omnipresent and extendable tutorial."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.16"
  s.add_dependency "nokogiri", "~> 1.6.1"
  s.add_dependency 'active_attr' # can be removed when rails >= 4, see Chapter
  s.add_dependency 'active_model_serializers'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-core"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-fire"
  s.add_development_dependency "capybara"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency 'combustion', '~> 0.5.1'
end
