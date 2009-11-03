task :build do
  source = "#{Rails.root}/config/database.yml.example"
  target = "#{Rails.root}/config/database.yml"
  FileUtils.cp(source, target)
  sh "ODIR=`pwd` && cd /var/www/shiftplan/shared/vendor/plugins/steam && git pull && cd $ODIR"
  sh "ln -nfs /var/www/shiftplan/shared/vendor/plugins/steam #{Rails.root}/vendor/plugins/steam"
  ENV['RAILS_ENV'] = 'test'
  system("sudo env PATH=$PATH rake gems:install")
  sh "ENV['RAILS_ENV'] = 'test' rake db:drop db:create db:migrate db:seed"
  sh "./script/server --port=3001 --environment=test -d && rake features"
  pid = File.open("#{Rails.root}/tmp/pids/server.pid")
  sh "kill -9 #{pid.read}"
end