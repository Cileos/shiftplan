task :build do 
  source = "#{Rails.root}/config/database.yml.example"
  target = "#{Rails.root}/config/database.yml"
  FileUtils.cp source, target
  Rake::Task['spec'].invoke
  Rake::Task['features'].invoke
end