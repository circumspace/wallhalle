#!/bin/sh
# Serves the site at http://localhost:6131 with live reload (override with
# PORT=...). 1313 is deliberately unused so a plain `hugo server` for other
# projects does not collide. All tooling runs in a container built from
# Containerfile.dev; nothing is installed on the host.
set -eu
cd "$(dirname "$0")"
rt=$(command -v podman || command -v docker)
port="${PORT:-6131}"
"$rt" image exists wallhalle-dev 2>/dev/null || "$rt" build -t wallhalle-dev -f Containerfile.dev .
exec "$rt" run --rm -it -p "$port:$port" -v "$PWD:/src" wallhalle-dev sh -c \
  "scripts/derive.sh && hugo server --bind 0.0.0.0 --baseURL http://localhost:$port/ --appendPort=false --noHTTPCache --poll 1s"
