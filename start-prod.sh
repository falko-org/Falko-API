#!/bin/bash

bundle check || bundle install

if bundle exec rails db:exists; then
  bundle exec rails db:migrate
else
  bundle exec rails db:create
  bundle exec rails db:migrate
fi

pidfile='/tmp/pids/server.pid'
if [ -f $pidfile ] ; then
	echo 'Server PID file already exists. Removing it...'
	rm $pidfile
fi

bundle exec rails s -p 3000 -b 0.0.0.0 

