set :stage_dir, File.dirname(__FILE__) + '/deploy/stages'
set :default_state, 'staging'

set :mett, '89.238.64.208'
set :gruetz, '89.238.64.209'
set :plock, '89.238.65.38'

require 'capistrano/ext/multistage'

# RVM bootstrap
set :rvm_type, :system
set(:rvm_ruby_string) { "1.9.3-p194@#{application}" }
require 'rvm/capistrano'

# bundler bootstrap
require 'bundler/capistrano'
load 'deploy/assets'

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

# delayed job
require "delayed/recipes"

# server details
set :user, 'application'
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :use_sudo, false

set :repository,  "git@github.com:Cileos/shiftplan.git"
set :local_repository, "."
set :git_enable_submodules, 1
set(:deploy_to) { "/home/#{user}/projects/#{application}/production" }

set :scm, :git

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Migrate the Database"
  task :migrate, :roles => :db do
    run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:migrate"
  end

  task :symlink_static_directories do
    run "rm -f #{current_release}/config/database.yml"
    run "ln -sf #{deploy_to}/shared/config/database.yml #{latest_release}/config/database.yml"
    #run "rm -f #{current_release}/config/application.yml"
    #run "ln -sf #{deploy_to}/shared/config/application.yml #{current_release}/config/application.yml"
    run "ln -sf #{deploy_to}/shared/uploads #{current_release}/public/uploads"
  end

  before "deploy:assets:precompile", "deploy:symlink_static_directories"

  desc "Delete the code we use to accelerate testing"
  task :delete_test_code do
    run "rm -f #{current_release}/app/controllers/test_acceleration_controller.rb"
  end

  before "deploy:assets:precompile", "deploy:delete_test_code"

  task :rake_task do
    if task = ENV['TASK']
      run "cd #{current_release} && RAILS_ENV=production bundle exec rake #{task}"
    else
      STDERR.puts "please specify the task you want to run with TASK="
    end
  end

end

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
