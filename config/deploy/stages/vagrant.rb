# deploys to a vagrant machine, running preferably on your local host
#
# Setup
# =====
#
# Clone the `Cileos/puppet` repository. bundle, `vagrant up`..
# When the machine is up, run `vagrant ssh-config --host cw-puppet-test` to get
# a snippet to append to your ~/.ssh/config.
#
#      vagrant ssh-config --host cw-puppet-test >> ~/.ssh/config
#
# After, modify the `IdentityFile` line to match the key you use for Cileos.
#
#      $ vim ~/.ssh/config
#
#      - IdentityFile /home/niklas/.vagrant.d/insecure_private_key
#      + IdentityFile ~/.ssh/pandur.key

set :local_vagrant, 'cw-puppet-test'

set :application, 'volksplaner'
set :branch do
  ENV['BRANCH'] || `git log -1 HEAD --format=format:%h`
end
set :rails_env, 'production'

role :web, local_vagrant
role :app, local_vagrant
role :db, local_vagrant, primary: true
