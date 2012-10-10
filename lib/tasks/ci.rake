unless ARGV.any? {|a| a =~ /^gems/} # Don't load anything when running the gems:* tasks

vendored_cucumber_bin = Dir["#{Rails.root}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first
$LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?

begin
  require 'cucumber/rake/task'
  namespace :cucumber do
    Cucumber::Rake::Task.new({:ci_javascripts_only => :'ci:setup:cucumber'}, 'Run all features tagged with @javascript') do |t|
      t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'ci_javascripts_only'
    end
    Cucumber::Rake::Task.new({:ci_without_javascripts => :'ci:setup:cucumber'}, 'Run all features not tagged with @javascript') do |t|
      t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'ci_without_javascripts'
    end

    desc 'Run all features on CI'
    task :ci => [:ci_without_javascripts, :ci_javascripts_only]
  end
end

begin
  require 'rspec/core/rake_task'
  namespace :spec do
    RSpec::Core::RakeTask.new({:ci => :'ci:setup:rspec'}) do |t|
      t.pattern = "./spec/**/*_spec.rb"
    end
  end
end

end
