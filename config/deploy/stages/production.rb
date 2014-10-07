set :application, "volksplaner"
set :branch, 'master'

role :web, mett
role :app, mett
role :db,  gruetz, :primary => true

set :flowdock_project_name, "Clockwork production"
set :flowdock_deploy_tags, ["deploy_production"]
