vendored_cucumber_bin = Dir["#{Rails.root}/vendor/{gems,plugins}/cucumber*/bin/cucumber"].first
$LOAD_PATH.unshift(File.dirname(vendored_cucumber_bin) + '/../lib') unless vendored_cucumber_bin.nil?
namespace :cucumber do
  Cucumber::Rake::Task.new(:ci_javascripts_only, 'Run all features tagged with @javascript') do |t|
    t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
    t.fork = true # You may get faster startup if you set this to false
    t.profile = 'ci_javascripts_only'
  end
  Cucumber::Rake::Task.new(:ci_without_javascripts, 'Run all features not tagged with @javascript') do |t|
    t.binary = vendored_cucumber_bin # If nil, the gem's binary is used.
    t.fork = true # You may get faster startup if you set this to false
    t.profile = 'ci_without_javascripts'
  end

  desc 'Run all features on CI'
  task :ci => [:ci_without_javascripts, :ci_javascripts_only]
end

namespace :spec do
  RSpec::Core::RakeTask.new(:ci) do |t|
    t.pattern = "./spec/**/*_spec.rb"
  end
end

