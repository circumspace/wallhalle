#!/bin/sh
# Serves the site at http://localhost:1313 with live reload. All tooling runs
# in a container built from Containerfile.dev; nothing is installed on the host.
set -eu
cd "$(dirname "$0")"
rt=$(command -v podman || command -v docker)
"$rt" image exists wallpaintr-dev 2>/dev/null || "$rt" build -t wallpaintr-dev -f Containerfile.dev .
exec "$rt" run --rm -it -p 1313:1313 -v "$PWD:/src" wallpaintr-dev sh -c \
  'scripts/derive.sh && hugo server --bind 0.0.0.0 --baseURL http://localhost:1313/ --appendPort=false --noHTTPCache --poll 1s'
