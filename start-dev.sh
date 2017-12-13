#!/bin/bash

bundle check || bundle install

bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed

pidfile='/Falko-2017.2-BackEnd/tmp/pids/server.pid'

if [ -f $pidfile ] ; then
	echo 'Server PID file already exists. Removing it...'
	rm $pidfile
fi

bundle exec rails s -p 3000 -b 0.0.0.0
