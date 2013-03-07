set :application, "volksplaner-staging"
set :branch do
  ENV['BRANCH'] || 'develop'
end
set :rails_env, 'production'

role :web, plock
role :app, plock
role :db, plock, :primary => true

namespace :deploy do

  desc "Seed the Database"
  task :seed, :roles => :db do
    if ENV['SEED'].nil?
      STDERR.puts "set the environment variable SEED to anything to confirm this harmful operation"
    else
      run "cd #{current_release} && RAILS_ENV=production bundle exec rake db:seed"
    end
  end

  task :notify do
    run "cd #{current_release} && ruby script/capistrano-done staging"
  end

  # TODO bot running on gruetz
  #after 'deploy:restart', 'deploy:notify'


end

