unless ARGV.any? {|a| a =~ /^gems/} # Don't load anything when running the gems:* tasks

if ENV['CI'].to_s == 'true'
  begin
    require 'ci/reporter/rake/rspec'     # use this if you're using RSpec
    require 'rspec/core/rake_task'
    namespace :spec do
      RSpec::Core::RakeTask.new({:ci => :'ci:setup:rspec'}) do |t|
        t.pattern = "./spec/**/*_spec.rb"
        t.rspec_opts = '--tag ~benchmark --backtrace'
      end

      RSpec::Core::RakeTask.new({:ci_benchmark => :'ci:setup:rspec'}) do |t|
        t.pattern = "./spec/**/*_spec.rb"
        t.rspec_opts = '--tag benchmark'
      end
    end
  end
end

end
