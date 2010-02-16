task :build do
  #the next two lines just show the java settings currently setted
  #in case the jdk will be updated change the ruby wrapper used for
  #passenger in apache conf
  system "export JAVA_HOME=/usr/lib/jvm/java-1.5.0-sun"
  system "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${JAVA_HOME}/jre/lib/i386:${JAVA_HOME}/jre/lib/i386/client"
  system "echo $JAVA_HOME"
  system "echo $LD_LIBRARY_PATH"
  system "ODIR=`pwd` && cd /var/www/shiftplan/shared/vendor/plugins/steam && git pull && cd $ODIR"
  system "ln -nfs /var/www/shiftplan/shared/vendor/plugins/steam #{Rails.root}/vendor/plugins/steam"
  system "ln -nfs /var/www/shiftplan/shared/config/database.yml.test #{Rails.root}/config/database.yml"
  system("sudo env PATH=$PATH bundle unlock")
  system("sudo env PATH=$PATH bundle install")
  system "rake environment RAILS_ENV=test db:drop db:create db:migrate"
  status = system "bundle exec rails server --p 3000 -e test -d && bundle exec cucumber features RAILS_ENV=test && bundle exec rspec ./spec && echo $?"
  pid = File.open("#{Rails.root}/tmp/pids/server.pid")
  system "kill -9 #{pid.read}"
  exit 1 unless status
end