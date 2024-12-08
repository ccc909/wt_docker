#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /src/tmp/pids/server.pid

# Create, migrate, and seed the database.
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"