#!/bin/sh
# Produces the deployable tree in public/ using the same container as dev.sh.
set -eu
cd "$(dirname "$0")"
rt=$(command -v podman || command -v docker)
"$rt" image exists wallhalle-dev 2>/dev/null || "$rt" build -t wallhalle-dev -f Containerfile.dev .
exec "$rt" run --rm -v "$PWD:/src" wallhalle-dev sh -c \
  'scripts/derive.sh && hugo --minify --cleanDestinationDir'
