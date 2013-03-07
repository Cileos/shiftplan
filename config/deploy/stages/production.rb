set :application, "volksplaner"
set :branch, 'master'

role :web, mett
role :app, mett
role :db,  gruetz, :primary => true
