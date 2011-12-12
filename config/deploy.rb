# RVM bootstrap
$:.unshift(File.expand_path("~/.rvm/lib"))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p0@shiftplan'
set :rvm_type, :user

# bundler bootstrap
require 'bundler/capistrano'

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :user, "staging"
set :use_sudo, false


set :application, "shiftplan"
set :repository,  "git@github.com:fritzek/shiftplan.git"
set :local_repository, "."
set :branch, 'master'
set :deploy_to, "/home/staging/www/#{application}"
set :git_enable_submodules, 1

set :scm, :git

role :web, "ci.shiftplan.de"
role :app, "ci.shiftplan.de"
role :db,  "ci.shiftplan.de", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :check, :roles => :app do
    run "sleep 2; wget -q -O /dev/null http://staging.shiftplan.de/"
  end

  desc "Migrate the Database"
  task :migrate, :roles => :db do
    run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:migrate"
  end

  desc "Seed the Database"
  task :seed, :roles => :db do
    if ENV['SEED'].nil?
      STDERR.puts "set the environment variable SEED to anything to confirm this harmful operation"
    else
      run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:seed"
    end
  end

  task :symlink_static_directories do
    run "rm -f #{current_release}/config/database.yml"
    run "ln -sf #{deploy_to}/shared/config/database.yml #{current_release}/config/database.yml"
    #run "rm -f #{current_release}/config/application.yml"
    #run "ln -sf #{deploy_to}/shared/config/application.yml #{current_release}/config/application.yml"
    #run "ln -sf #{deploy_to}/shared/system #{current_release}/public/"
  end

  after 'deploy:symlink', 'deploy:symlink_static_directories'

  task :compile_assets, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end

  after 'deploy:symlink', 'deploy:compile_assets'
end

namespace :setup do
  task :all, :roles => :app do
  end

  task :packages, :roles => :app do
    sudo "apt-get -y install git-core build-essential"
  end
end

