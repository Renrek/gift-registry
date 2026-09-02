#!/usr/bin/env sh
set -eu

# Create a system invitation (no inviter, no auto-friend connection) for the given email.
# Run this from the repository root in development.

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$ROOT_DIR"

if [ $# -ne 1 ]; then
  echo "Usage: $0 <email>" >&2
  exit 1
fi

docker compose exec php php bin/console app:user:invite "$1"
