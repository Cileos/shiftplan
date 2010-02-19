# !!!!!!!!!!!!!!!!
# just use this rake task only if you find a way to get around the bundler


task :build do
  #in case the jdk will be updated, change the ruby wrapper used for
  #passenger in apache conf and these java settings here
  #system "export JAVA_HOME=/usr/lib/jvm/java-1.5.0-sun"
  #system "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${JAVA_HOME}/jre/lib/i386:${JAVA_HOME}/jre/lib/i386/client"
  #system "echo $JAVA_HOME"
  #system "echo $LD_LIBRARY_PATH"
  #update steam gem
  #system "ODIR=`pwd` && cd /var/www/shiftplan/shared/vendor/plugins/steam && git pull && cd $ODIR"
  #system "ln -nfs /var/www/shiftplan/shared/vendor/plugins/steam #{Rails.root}/vendor/plugins/steam"
  #prepare db config
  #system "ln -nfs /var/www/shiftplan/shared/config/database.yml.test #{Rails.root}/config/database.yml"
  #run bundler
  #system "env PATH=$PATH bundle install --relock"
  #do db setup
  #system "rake environment RAILS_ENV=test db:drop db:create db:migrate"
  #start server and send to background
  #system "nohup rails server -p 3000 -e test 2>/dev/null 1>/dev/null &"
  #do the test
  #status = system "cucumber features RAILS_ENV=test && rspec ./spec && echo $?"
  #kill the server
  #pid = File.open("#{Rails.root}/tmp/pids/server.pid")
  #system "kill -9 #{pid.read}"
  #exit 1 unless status
end