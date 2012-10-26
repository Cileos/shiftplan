set :stage_dir, File.dirname(__FILE__) + '/deploy/stages'
set :default_state, 'staging'

set :mett, '89.238.64.208'
set :gruetz, '89.238.64.209'

require 'capistrano/ext/multistage'

# RVM bootstrap
require 'rvm/capistrano'

# bundler bootstrap
require 'bundler/capistrano'
load 'deploy/assets'

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :use_sudo, false

set :repository,  "git@github.com:Cileos/shiftplan.git"
set :local_repository, "."
set :git_enable_submodules, 1

set :scm, :git

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

  task :symlink_static_directories do
    run "rm -f #{current_release}/config/database.yml"
    run "ln -sf #{deploy_to}/shared/config/database.yml #{latest_release}/config/database.yml"
    #run "rm -f #{current_release}/config/application.yml"
    #run "ln -sf #{deploy_to}/shared/config/application.yml #{current_release}/config/application.yml"
    #run "ln -sf #{deploy_to}/shared/system #{current_release}/public/"
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
