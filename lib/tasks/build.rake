task :build do 
  source = "#{Rails.root}/config/database.yml.example"
  target = "#{Rails.root}/config/database.yml"
  FileUtils.cp source, target
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  sh "./script/server -d"
  Rake::Task['spec'].invoke
  Rake::Task['features'].invoke
  pid = File.open "#{Rails.root}/tmp/pids/server.pid"
  sh "kill #{pid.read}"
end