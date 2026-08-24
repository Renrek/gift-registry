#!/usr/bin/env sh
set -eu

# One-time production setup helper.
# Run this from the repository root on the production server.

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$ROOT_DIR"

if [ ! -f "app/.env.prod.local" ]; then
  if [ -f "app/.env.prod.local.example" ]; then
    cp app/.env.prod.local.example app/.env.prod.local
    echo "Created app/.env.prod.local from template."
    echo "Edit app/.env.prod.local with real production secrets before deploy."
  else
    echo "Missing app/.env.prod.local.example template." >&2
    exit 1
  fi
fi

git submodule sync --recursive
git submodule update --init --recursive

docker compose -f docker-compose.prod.yml build php
docker compose -f docker-compose.prod.yml up -d

echo "Bootstrap complete. Next: run ./scripts/production/deploy.sh"