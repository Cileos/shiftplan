task :build do
  system "ODIR=`pwd` && cd /var/www/shiftplan/shared/vendor/plugins/steam && git pull && cd $ODIR"
  system "ln -nfs /var/www/shiftplan/shared/vendor/plugins/steam #{Rails.root}/vendor/plugins/steam"
  source = "#{Rails.root}/config/database.yml.example"
  target = "#{Rails.root}/config/database.yml"
  FileUtils.cp(source, target)
  ENV['RAILS_ENV'] = 'test'
  system("sudo env PATH=$PATH rake gems:install")
  system "rake environment RAILS_ENV=test db:drop db:create db:migrate db:seed"
  system "./script/server --port=3001 --environment=test -d && rake environment RAILS_ENV=test features"
  pid = File.open("#{Rails.root}/tmp/pids/server.pid")
  system "kill -9 #{pid.read}"
end