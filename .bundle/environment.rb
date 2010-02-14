require 'digest/sha1'

# DO NOT MODIFY THIS FILE
module Bundler
  FINGERPRINT = "609d3383a93a134d8e6904f3b0ddd00df3018643"
  LOAD_PATHS = ["/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/nokogiri-1.4.1/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/nokogiri-1.4.1/ext", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/rjb-1.2.0/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/text-hyphen-1.0.0/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/builder-2.1.2/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/json_pure-1.2.0/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/i18n-0.3.3/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/linecache-0.43/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/ruby-debug-base-0.10.3/lib", "/Users/clemens/.bundle/gems/bundler-0.9.5/lib", "/Users/clemens/.bundle/gems/arel-0.2.1/lib", "/Users/clemens/.bundle/bundler/gems/rails-16a5e918a06649ffac24fd5873b875daf66212ad-d68f8ba5c303556ecb8625dd146184d68b704e83/activemodel/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/mime-types-1.16/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/mail-2.1.2/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/abstract-1.0.0/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/erubis-2.6.5/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/machinist-1.0.6/lib", "/Users/clemens/.bundle/gems/thor-0.13.1/lib", "/Users/clemens/.bundle/gems/polyglot-0.3.0/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/treetop-1.4.3/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/memcache-client-1.7.8/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/rack-1.1.0/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/rack-test-0.5.3/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/webrat-0.7.0/lib", "/Users/clemens/.bundle/gems/rack-mount-0.4.7/lib", "/Users/clemens/.bundle/bundler/gems/rails-16a5e918a06649ffac24fd5873b875daf66212ad-d68f8ba5c303556ecb8625dd146184d68b704e83/actionpack/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/mysql-2.8.1/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/mysql-2.8.1/ext", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249%global/gems/rake-0.8.7/lib", "/Users/clemens/.bundle/bundler/gems/rails-16a5e918a06649ffac24fd5873b875daf66212ad-d68f8ba5c303556ecb8625dd146184d68b704e83/railties/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/diff-lcs-1.1.2/lib", "/Users/clemens/.bundle/gems/gravtastic-2.2.0/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/columnize-0.3.1/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/text-format-1.0.0/lib", "/Users/clemens/.bundle/bundler/gems/rails-16a5e918a06649ffac24fd5873b875daf66212ad-d68f8ba5c303556ecb8625dd146184d68b704e83/actionmailer/lib", "/Users/clemens/.bundle/bundler/gems/rails-16a5e918a06649ffac24fd5873b875daf66212ad-d68f8ba5c303556ecb8625dd146184d68b704e83/activerecord/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/faker-0.3.1/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/locator-0.0.3/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/tzinfo-0.3.16/lib", "/Users/clemens/.bundle/bundler/gems/rails-16a5e918a06649ffac24fd5873b875daf66212ad-d68f8ba5c303556ecb8625dd146184d68b704e83/activesupport/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/ruby-debug-0.10.3/cli", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/rspec-core-2.0.0.a5/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/rspec-expectations-2.0.0.a5/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/rspec-mocks-2.0.0.a5/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/rspec-2.0.0.a5/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/rspec-rails-2.0.0.a6/lib", "/Users/clemens/.bundle/bundler/gems/rails-16a5e918a06649ffac24fd5873b875daf66212ad-d68f8ba5c303556ecb8625dd146184d68b704e83/activeresource/lib", "/Users/clemens/.bundle/bundler/gems/rails-16a5e918a06649ffac24fd5873b875daf66212ad-d68f8ba5c303556ecb8625dd146184d68b704e83/", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/term-ansicolor-1.0.4/lib", "/Users/clemens/.rvm/gems/ruby-1.8.7-p249/gems/cucumber-0.6.2/lib"]
  AUTOREQUIRES = {:test=>["machinist", "faker", "cucumber", "locator", "rjb", "rspec", "rspec-rails"], :default=>["rails", "rack", "mysql", "gravtastic"], :cucumber=>["ruby-debug", "cucumber", "locator", "rjb", "rspec", "rspec-rails"], :cucumber_development=>["ruby-debug"], :development=>["ruby-debug"]}

  def self.match_fingerprint
    print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))
    unless print == FINGERPRINT
      abort 'Gemfile changed since you last locked. Please `bundle lock` to relock.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    LOAD_PATHS.each { |path| $LOAD_PATH.unshift path }
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group] || []).each { |file| Kernel.require file }
    end
  end

  # Setup bundle when it's required.
  setup
end
