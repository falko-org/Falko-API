run:
	@echo "*********************************\n"
	@echo "Lifting up the whole environment!\n"
	@echo "*********************************\n"
	@docker-compose up

quiet-run:
	@echo "*********************************\n"
	@echo "Lifting up the whole environment!\n"
	@echo "*********************************\n"
	@docker-compose up --detach

run-db:
	@echo "************************\n"
	@echo "Lifting up the database!\n"
	@echo "************************\n"
	@docker-compose up falko-database

run-api:
	@echo "*************************\n"
	@echo "Lifting up the api!\n"
	@echo "*************************\n"
	@docker-compose up falko-server

console:
	@echo "*************************\n"
	@echo "Entering the rails console!\n"
	@echo "*************************\n"
	@docker-compose falko-server rails console

create-db:
	@echo "*************************\n"
	@echo "Creating rails database!\n"
	@echo "*************************\n"
	@docker-compose exec falko-server bundle exec rails db:create

seed:
	@echo "*************************\n"
	@echo "Executing database seed scripts\n"
	@echo "*************************\n"
	@docker-compose exec falko-server bundle exec rails db:seed

down:
	@echo "******************************\n"
	@echo "Dropping down the environment!\n"
	@echo "******************************\n"
	@docker-compose down

ps:
	@echo "************************\n"
	@echo "Listing running services\n"
	@echo "************************\n"
	@docker-compose ps

migrate:
	@echo "******************\n"
	@echo "Migrating database\n"
	@echo "******************\n"
	@docker-compose exec falko-server bundle exec rails db:migrate

test:
	@echo "***************************\n"
	@echo "Executing all api tests\n"
	@echo "***************************\n"
	@docker-compose exec falko-server bundle exec rails test

rm-network:
	@echo "**********************************\n"
	@echo "Removing all networks!\n"
	@echo "**********************************\n"
	@docker network rm $(sudo docker network ls -q)

rm-flk-network:
	@echo "**********************************\n"
	@echo "Removing Falko network!\n"
	@echo "**********************************\n"
	@docker network rm falko-backend

rm-volume:
	@echo "*********************\n"
	@echo "Removing all volumes!\n"
	@echo "*********************\n"
	@docker volume rm $(sudo docker volume ls -q)

.PHONY: no_targets__ list
no_targets__:
list:
	@sh -c "$(MAKE) -p no_targets__ -prRn -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'"
