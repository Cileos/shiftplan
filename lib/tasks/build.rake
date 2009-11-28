task :build do
  #the next two lines just show the java settings currently setted
  #in case the jdk will be updated change the ruby wrapper used for
  #passenger in apache conf
  system "echo $JAVA_HOME"
  system "echo $LD_LIBRARY_PATH"
  system "ODIR=`pwd` && cd /var/www/shiftplan/shared/vendor/plugins/steam && git pull && cd $ODIR"
  system "ln -nfs /var/www/shiftplan/shared/vendor/plugins/steam #{Rails.root}/vendor/plugins/steam"
  system "ln -nfs /var/www/shiftplan/shared/config/database.yml.test #{Rails.root}/config/database.yml"
  system("sudo env PATH=$PATH rake gems:install RAILS_ENV=test")
  system "rake environment RAILS_ENV=test db:drop db:create db:migrate db:seed"
  status = system "./script/server --port=3000 --environment=test -d && cucumber features/*feature && rake RAILS_ENV=test && echo $?"
  pid = File.open("#{Rails.root}/tmp/pids/server.pid")
  system "kill -9 #{pid.read}"
  exit 1 unless status
end