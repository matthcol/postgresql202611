#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_name=pg-dbmovie

# --renew-anon-volumes : recree les volumes anonymes 
docker compose \
  -f "$script_dir/docker-compose.yml" \
  -f "$script_dir/docker-compose.persist.yml" \
  -p "$project_name" \
  up -d --renew-anon-volumes "$@"
