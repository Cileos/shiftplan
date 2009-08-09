task :build do 
  source = "#{Rails.root}/config/database.yml.example"
  target = "#{Rails.root}/config/database.yml"
  FileUtils.cp source, target
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke
  Rake::Task['spec'].invoke
  sh "./script/server --port=3001 --environment=test -d"
  sh "ls #{Rails.root}/tmp/pids"
  sh "wget http://localhost:3001"
  sh "rm index.html"
  Rake::Task['features'].invoke
end