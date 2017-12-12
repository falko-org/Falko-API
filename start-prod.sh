#!/bin/bash

bundle check || bundle install

while ! pg_isready -h dokku.postgres.falko-database -p 5432 -q -U postgres; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

if bundle exec rake db:exists; then
  bundle exec rake db:migrate
else
  bundle exec rake db:create
  bundle exec rails db:migrate
fi

pidfile='/Falko-2017.2-BackEnd/tmp/pids/server.pid'

if [ -f $pidfile ] ; then
	echo 'Server PID file already exists. Removing it...'
	rm $pidfile
fi

bundle exec puma -C config/puma.rb
