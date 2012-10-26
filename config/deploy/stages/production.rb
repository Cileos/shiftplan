set :user, 'application'
set :branch, 'master'
set :deploy_to, "/home/#{user}/projects/volksplaner/production"

role :web, mett
role :app, mett
role :db,  gruetz, :primary => true
