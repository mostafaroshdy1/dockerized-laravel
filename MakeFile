#!/bin/bash

create_project() {
  mkdir -p src
  docker compose build
  docker compose up -d
  docker compose exec app composer create-project --prefer-dist laravel/laravel .
  docker compose exec app php artisan key:generate
  docker compose exec app php artisan storage:link
  docker compose exec app chmod -R 777 storage bootstrap/cache
  docker compose exec app npm install
}

init() {
  docker compose up -d --build
  docker compose exec app composer install
  docker compose exec app cp .env.example .env
  docker compose exec app php artisan key:generate
  docker compose exec app php artisan storage:link
  docker compose exec app chmod -R 777 storage bootstrap/cache
  docker compose exec app npm install
  docker compose exec app php artisan migrate:fresh --seed
}

up() {
  docker compose up -d
}

down() {
  docker compose down --remove-orphans
}

destroy() {
  docker compose down --rmi all --volumes --remove-orphans
}

restart() {
  down
  up
}

remake() {
  destroy
  init
}

case "$1" in
create_project)
  create_project
  ;;
init)
  init
  ;;
up)
  up
  ;;
down)
  down
  ;;
destroy)
  destroy
  ;;
restart)
  restart
  ;;
remake)
  remake
  ;;
*)
  echo "Usage: $0 {create_project|init|up|down|destroy|restart|remake}"
  exit 1
  ;;
esac
