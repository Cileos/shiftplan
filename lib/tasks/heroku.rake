namespace :deploy do
  PRODUCTION_APP = 'shiftplanapp'
  STAGING_APP = 'shiftplandemo'

  def run(*cmd)
    system(*cmd)
    raise "Command #{cmd.inspect} failed!" unless $?.success?
  end

  def confirm(message)
    print "\n#{message}\nAre you sure? [Yn] "
    raise 'Aborted' unless STDIN.gets.chomp == 'Y'
  end

  desc "Deploy to staging"
  task :staging do
    confirm('This will deploy your current HEAD to staging.')
    # as long as heroku doesn't respect bundler groups we need different Gemfile's
    run "cp Gemfile.heroku Gemfile"
    # unset sprocket caching as heroku has read-only file systen
    run "sed -i.bak 's/unless/#unless/' config/initializers/sprockets.rb && rm config/initializers/sprockets.rb.bak"
    # commit your work
    run "git add Gemfile"
    run "git add config/initializers/sprockets.rb"
    # regenerate Gemfile.lock
    run "bundle check || env PATH=$PATH bundle install"
    run "git add Gemfile.lock"
    run "git commit -m 'heroku setup'"
    # run the deployment
    run "git push git@heroku.com:#{STAGING_APP}.git HEAD:master -f"
    run "heroku rake db:reset --app #{STAGING_APP}"
    run "heroku rake db:setup --app #{STAGING_APP}"
    # reset after deploy your local changes
    run "git reset --hard origin/master"
  end

  desc "Deploy to production"
  task :production do
    iso_date = Time.now.strftime('%Y-%m-%dT%H%M%S')

    confirm('This will deploy the master branch to production.')

    puts "Deployment preparation…"
    # as long as heroku doesn't respect bundler groups we need different Gemfile's
    run "cp Gemfile.heroku Gemfile"
    # unset sprocket caching as heroku has read-only file systen
    run "sed -i.bak 's/unless/#unless/' config/initializers/sprockets.rb && rm config/initializers/sprockets.rb.bak"
    # commit your work
    run "git add Gemfile"
    run "git add config/initializers/sprockets.rb"
    # regenerate Gemfile.lock
    run "bundle check || env PATH=$PATH bundle install"
    run "git add Gemfile.lock"
    run "git commit -m 'heroku setup'"
    
    puts "Backing up…"
    Dir.chdir(File.join(File.dirname(__FILE__), *%w[.. .. backups])) do
      run "heroku bundles:destroy deploybackup --app #{PRODUCTION_APP}" if `heroku bundles --app #{PRODUCTION_APP}` =~ /deploybackup/
      run "heroku bundles:capture deploybackup --app #{PRODUCTION_APP}"
      puts " … waiting for Heroku"
      while sleep(5) && `heroku bundles --app #{PRODUCTION_APP}` !~ /complete/
        puts " … still waiting"
      end
      puts " … downloading backup"
      run "heroku bundles:download deploybackup --app #{PRODUCTION_APP}"
      run "mv #{PRODUCTION_APP}{,_#{iso_date}}.tar.gz"
    end
    
    puts "Reset to origin for pushing new tag…"
    # reset after deploy your local changes
    run "git reset --hard origin/master"

    puts "Pushing new tag…"
    tag_name = "heroku-#{iso_date}"
    puts "Tagging as #{tag_name}…"
    run "git tag #{tag_name} master"
    run "git push origin #{tag_name}"

    puts "Prepare again…"
    # as long as heroku doesn't respect bundler groups we need different Gemfile's
    run "cp Gemfile.heroku Gemfile"
    # unset sprocket caching as heroku has read-only file systen
    run "sed -i.bak 's/unless/#unless/' config/initializers/sprockets.rb && rm config/initializers/sprockets.rb.bak"
    # commit your work
    run "git add Gemfile"
    run "git add config/initializers/sprockets.rb"
    # regenerate Gemfile.lock
    run "bundle check || env PATH=$PATH bundle install"
    run "git add Gemfile.lock"
    run "git commit -m 'heroku setup'"
    
    # run the deployment
    puts "Deploying…"
    run "git push git@heroku.com:#{PRODUCTION_APP}.git HEAD:master"

    puts "Migrating…"
    run "heroku rake db:migrate --app #{PRODUCTION_APP}"
    
    puts "Finishing…"
    # reset after deploy your local changes
    run "git reset --hard origin/master"
    
  end

end
