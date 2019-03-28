#!/bin/bash

if [[ $1 = "start-server" ]]; then
  mkdir -p /app/tmp/pids
  rm /app/tmp/pids/*

  bundle install -j8 --path vendor/bundle

  yarn install

  if [[ $NODE_ENV = "production" ]]; then
    bundle exec rails webpacker:compile
  fi

  rm -rf /var/www/*
  cp -r /app/public/* /var/www/

  if [[ $RAILS_ENV != "production" && -f Procfile.dev ]]; then
    bundle exec foreman start -f Procfile.dev
  else
    bundle exec foreman start
  fi
else
  exec "$@"
fi
