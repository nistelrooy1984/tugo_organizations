.DEFAULT_GOAL := usage

build:
	docker-compose build

db-create:
	export DB_PORT=$()
	docker-compose up -d
	docker-compose exec app bin/rails db:create

up:
	rm -rf tmp/pids/server.pid
	docker-compose up -d

up-bridge:
	if [ -z "$$(docker network ls -q -f name=tugo_bridge)"]; then docker network create tugo_bridge; fi
	rm -rf tmp/pids/server.pid
	docker-compose -f docker-compose-bridge.yaml up

down:
	docker-compose down

stop:
	docker-compose stop

db-migrate-up:
# For container is running on Linux(Ubuntu, CentOS)
# 	scripts/db_migrate "postgres://localhost:5620/app_development?sslmode=disable&user=postgres" up
# 	scripts/db_migrate "postgres://localhost:5620/app_test?sslmode=disable&user=postgres" up
# For container is running on Windows or MacOS
	scripts/db_migrate "postgres://host.docker.internal:5620/app_development?sslmode=disable&user=postgres" up
	scripts/db_migrate "postgres://host.docker.internal:5620/app_test?sslmode=disable&user=postgres" up
	docker-compose run --rm app ./bin/rails db:environment:set RAILS_ENV=test

db-migrate-down:
# For container is running on Linux(Ubuntu, CentOS)
# 	scripts/db_migrate "postgres://localhost:5620/app_development?sslmode=disable&user=postgres" down
# 	scripts/db_migrate "postgres://localhost:5620/app_test?sslmode=disable&user=postgres" down
# For container is running on Windows or MacOS
	scripts/db_migrate "postgres://host.docker.internal:5620/app_development?sslmode=disable&user=postgres" down
	scripts/db_migrate "postgres://host.docker.internal:5620/app_test?sslmode=disable&user=postgres" down

db-drop-create:
	docker-compose run --rm app ./bin/rails db:environment:set RAILS_ENV=development
	docker-compose run --rm -e RAILS_ENV=development app bundle exec rake db:drop db:create

reset: db-drop-create db-migrate-up

bundle:
	docker-compose run --rm app bundle install

bundle-update:
	docker-compose run --rm app bundle update

console:
	docker-compose run --rm app bundle exec rails console

rubocop-fix:
	docker-compose run --rm app bundle exec rubocop --auto-correct

rspec:
	docker-compose run --rm app bundle exec rspec ${OPTS} --profile -- ${TARGETS}

update-pb:
	docker-compose run --rm app sh scripts/proto_converter.sh ${SERVICE}

attach:
	docker container attach $(docker-compose ps -q | head -n 1)

bash:
	docker-compose exec app /bin/bash

usage:
	@echo usage: [build, db-create, up, up-bridge, down, stop, db-migrate-up, db-migrate-down, db-drop-create, reset, bundle, bundle-update, console, rubocop-fix, rspec, update-pb, attach, bash]
