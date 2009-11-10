task :build do
  #the next two lines just show the java settings currently setted
  #in case the jdk will be updated change the ruby wrapper used for
  #passenger in apache conf
  system "echo $JAVA_HOME"
  system "echo $LD_LIBRARY_PATH"
  system "ODIR=`pwd` && cd /var/www/shiftplan/shared/vendor/plugins/steam && git pull && cd $ODIR"
  system "ln -nfs /var/www/shiftplan/shared/vendor/plugins/steam #{Rails.root}/vendor/plugins/steam"
  source = "#{Rails.root}/config/database.yml.example"
  target = "#{Rails.root}/config/database.yml"
  FileUtils.cp(source, target)
  system("sudo env PATH=$PATH rake gems:install")
  system "rake environment RAILS_ENV=test db:drop db:create db:migrate db:seed"
  status = system "./script/server --port=3000 --environment=test -d && rake environment RAILS_ENV=test features && echo $?"
  pid = File.open("#{Rails.root}/tmp/pids/server.pid")
  system "kill -9 #{pid.read}"
  exit 1 unless status
end