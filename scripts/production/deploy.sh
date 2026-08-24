#!/usr/bin/env sh
set -eu

# Manual production deployment helper.
# Run this from the repository root on the production server.

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$ROOT_DIR"

TARGET_BRANCH=${1:-main}

echo "Deploying branch: $TARGET_BRANCH"

git fetch origin "$TARGET_BRANCH"
git checkout "$TARGET_BRANCH"
git reset --hard "origin/$TARGET_BRANCH"
git submodule sync --recursive
git submodule update --init --recursive

docker run --rm \
  -v "$PWD/app:/app" \
  -w /app \
  node:22-alpine \
  sh -c 'npm ci && npm run build'

docker compose -f docker-compose.prod.yml build php
docker compose -f docker-compose.prod.yml up -d

docker compose -f docker-compose.prod.yml exec -T php \
  composer install --no-dev --prefer-dist --optimize-autoloader --no-interaction

docker compose -f docker-compose.prod.yml exec -T php \
  php bin/console cache:clear --env=prod --no-debug

docker compose -f docker-compose.prod.yml exec -T php \
  php bin/console doctrine:migrations:migrate --no-interaction

docker compose -f docker-compose.prod.yml ps

echo "Deployment complete."