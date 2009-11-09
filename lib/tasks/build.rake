task :build do
  system "export JAVA_HOME=/usr/lib/jvm/java-1.5.0-sun"
  system "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${JAVA_HOME}/jre/lib/i386:${JAVA_HOME}/jre/lib/i386/client"
  system "echo $JAVA_HOME"
  system "echo $LD_LIBRARY_PATH"
  system "ODIR=`pwd` && cd /var/www/shiftplan/shared/vendor/plugins/steam && git pull && cd $ODIR"
  system "ln -nfs /var/www/shiftplan/shared/vendor/plugins/steam #{Rails.root}/vendor/plugins/steam"
  source = "#{Rails.root}/config/database.yml.example"
  target = "#{Rails.root}/config/database.yml"
  FileUtils.cp(source, target)
  ENV['RAILS_ENV'] = 'test'
  system("sudo env PATH=$PATH rake gems:install")
  system "rake environment RAILS_ENV=test db:drop db:create db:migrate db:seed"
  system "./script/server --port=3001 --environment=test -d && rake environment RAILS_ENV=test features && echo $?"
  pid = File.open("#{Rails.root}/tmp/pids/server.pid")
  system "kill -9 #{pid.read}"
end