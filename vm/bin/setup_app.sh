#!/usr/bin/env bash

set -e

whoami
id
source ~/.rvm/scripts/rvm
[ -e ~/clockwork ] || ln -sf /vagrant ~/clockwork
rvm rvmrc warning ignore ~/clockwork/.rvmrc
rvm rvmrc trust ~/clockwork/.rvmrc
# TODO ramdisk
mkdir -p ~/clockwork/log || true
cd ~/clockwork
source .rvmrc
rvm info
function createdb_unless_exists()  {
  name=$1
  echo "creating database $name"
  if psql -lqt | cut -d \| -f 1 | grep -w $name; then
    echo "  already exists"
  else
    createdb --template=template0 -E UTF8 $name
  fi
}
createdb_unless_exists clockwork_development
createdb_unless_exists clockwork_test
createdb_unless_exists clockwork_production

[ -r config/database.yml ] && cp -nv config/database.yml{,.previous}
cat > config/database.yml <<-EOYAML
defaults: &defaults
  adapter: postgresql
  encoding: utf-8
  pool: 5
  template: template0

development:
  database: clockwork_development
  min_messages: notice
  <<: *defaults

test:
  database: clockwork_test
  <<: *defaults

production:
  database: clockwork_production
  <<: *defaults
EOYAML
#cp -nv config/application.yml{.example,}
#cp -nv config/features.yml{.example,}
#cp -nv config/sprite_factory.yml{.example,}
bundle install
bundle exec rake db:migrate --trace
bundle exec rake db:migrate RAILS_ENV=test --trace
