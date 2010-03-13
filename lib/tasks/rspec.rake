require 'rspec'
require 'rspec/core/rake_task'

Rspec::Core::RakeTask.new(:spec)

desc "Run all examples using rcov"
Rspec::Core::RakeTask.new :rcov => :cleanup_rcov_files do |t|
  t.rcov = true
  t.rcov_opts =  %[-Ilib -Ispec --exclude "mocks,expectations,gems/*,spec/controllers,spec/helpers,spec/lib,spec/models,spec/spec_helper.rb,db/*,/Library/Ruby/*,config/*,config/initializers/*"]
  t.rcov_opts << %[--no-html --aggregate coverage.data]
end

task :cleanup_rcov_files do
  rm_rf 'coverage.data'
end

task :clobber do
  rm_rf 'pkg'
  rm_rf 'tmp'
  rm_rf 'coverage'
end

if RUBY_VERSION.to_f >= 1.9
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = %w{--format progress}
  end

  task :default => [:check_dependencies, :spec, :cucumber]
else
  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.rcov = true
    t.rcov_opts =  %[-Ilib -Ispec --exclude "mocks,expectations,gems/*,features,spec/ruby_forker,spec/rspec,spec/resources,spec/lib,spec/spec_helper.rb,db/*,/Library/Ruby/*,config/*"]
    t.rcov_opts << %[--text-report --sort coverage --aggregate coverage.data]
    t.cucumber_opts = %w{--format progress}
  end

  task :default => [:check_dependencies, :rcov, :cucumber]
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rspec-core #{Rspec::Core::Version::STRING}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
