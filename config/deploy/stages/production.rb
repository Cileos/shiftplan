set :rvm_type, :system
set :rvm_ruby_string, '1.9.3-p194@volksplaner'
set :application, "volksplaner"

set :user, 'application'
set :branch, 'master'
set :deploy_to, "/home/#{user}/projects/volksplaner/production"

role :web, mett
role :app, mett
role :db,  gruetz, :primary => true
