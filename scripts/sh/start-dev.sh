#!/bin/bash

bundle check || bundle install

while ! pg_isready -h falko-database -p 5432 -q -U postgres; do
  >&2 echo "Postgres is unavailable - sleeping..."
  sleep 1
done

>&2 echo "Postgres is up - executing commands..."

if bundle exec rake db:exists; then
	>&2 echo "Database exists, only migrating..."
	bundle exec rake db:migrate
else 
	>&2 echo "Database doesn't exists, creating and migrating it..."
	bundle exec rake db:create
	bundle exec rake db:migrate
fi

bundle exec rake db:seed

pidfile='/Falko-2017.2-BackEnd/tmp/pids/server.pid'

if [ -f $pidfile ] ; then
	echo 'Server PID file already exists. Removing it...'
	rm $pidfile
fi

bundle exec rails s -p 3000 -b 0.0.0.0
