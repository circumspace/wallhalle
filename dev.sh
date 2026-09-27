#!/bin/sh
# Runs the repo's tooling in the `dev` target of the Dockerfile, with the
# repo bind-mounted at /src; nothing is installed on the host. Works with
# podman or docker (CONTAINER_RUNTIME picks one when both are installed).
#
#   ./dev.sh              derive, then serve http://localhost:6131 with live
#                         reload (PORT overrides; 1313 stays free for other
#                         hugo work)
#   ./dev.sh <cmd> ...    run a command instead, e.g. ./dev.sh scripts/fetch.sh
set -eu
cd "$(dirname "$0")"
rt=${CONTAINER_RUNTIME:-$(command -v podman || command -v docker || true)}
[ -n "$rt" ] || { echo "dev.sh: needs podman or docker" >&2; exit 1; }
# Always build: the layer cache makes an unchanged image a no-op, and a
# changed Dockerfile is picked up.
"$rt" build -q --target dev -t wallhalle-dev . >/dev/null
tty=; [ -t 0 ] && [ -t 1 ] && tty=-t
if [ $# -gt 0 ]; then
  exec "$rt" run --rm -i $tty -v "$PWD:/src" wallhalle-dev "$@"
fi
port=${PORT:-6131}
exec "$rt" run --rm -i $tty -p "$port:$port" -v "$PWD:/src" wallhalle-dev sh -c \
  "scripts/derive.sh && hugo server --bind 0.0.0.0 --port $port --baseURL http://localhost:$port/ --appendPort=false --noHTTPCache --poll 1s"
