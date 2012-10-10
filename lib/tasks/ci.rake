unless ARGV.any? {|a| a =~ /^gems/} # Don't load anything when running the gems:* tasks

begin
  require 'rspec/core/rake_task'
  namespace :spec do
    RSpec::Core::RakeTask.new({:ci => :'ci:setup:rspec'}) do |t|
      t.pattern = "./spec/**/*_spec.rb"
    end
  end
end

end
