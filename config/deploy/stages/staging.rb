set :user, "staging"
set :branch do
  ENV['BRANCH'] || 'develop'
end
set :application, "shiftplan"
set :deploy_to, "/home/staging/www/#{application}"

role :web, "ci.shiftplan.de"
role :app, "ci.shiftplan.de"
role :db,  "ci.shiftplan.de", :primary => true

set :rvm_type, :user
set :rvm_ruby_string, '1.9.3-p194@shiftplan'

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

  after 'deploy:restart', 'deploy:notify'


end

