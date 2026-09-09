#!/bin/sh
# Produces the deployable tree in public/ using the same container as dev.sh.
set -eu
cd "$(dirname "$0")"
rt=$(command -v podman || command -v docker)
"$rt" image exists wallpaintr-dev 2>/dev/null || "$rt" build -t wallpaintr-dev -f Containerfile.dev .
exec "$rt" run --rm -v "$PWD:/src" wallpaintr-dev sh -c \
  'scripts/derive.sh && hugo --minify --baseURL "${BASE_URL:-http://localhost:1313/}"'
