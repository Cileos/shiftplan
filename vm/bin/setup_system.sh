#!/usr/bin/env bash


sudo su - postgres -c bash <<-EOSH
[ 0 -lt "\$(psql --tuples-only -c "SELECT COUNT(*) FROM pg_user WHERE usename = 'vagrant'")" ] || createuser --createdb --superuser --no-createrole --echo vagrant
EOSH
