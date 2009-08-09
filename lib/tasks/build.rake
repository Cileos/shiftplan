task :build do 
  source = "#{Rails.root}/config/database.yml.example"
  target = "#{Rails.root}/config/database.yml"
  FileUtils.cp source, target
  ENV['RAILS_ENV'] = 'test'
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  Rake::Task['spec'].invoke
  sh "./script/server --port=3001 --environment=test -d && rake features"
  pid = File.open "#{Rails.root}/tmp/pids/server.pid"
  sh "kill -9 #{pid.read}"
end