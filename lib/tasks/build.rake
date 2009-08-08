task :build do
  Rake::Task['spec'].invoke
  Rake::Task['features'].invoke
end