#!/bin/sh
# Entrypoint of the tools image. Points originals/, static/w and static/dl
# at the mounted volume, downloads what is missing, then derives
# thumbnails, previews and cuts. Size data and QR codes are skipped: they
# are committed and baked into the site image.
#
# A failed download does not stop the derive step: every painting whose
# original is present gets its files, and the Job still exits non-zero so
# the missing one is visible in the Kustomization status.
set -u
DATA=${DATA_DIR:-/data}
mkdir -p "$DATA/originals" "$DATA/w" "$DATA/dl"
cd "$(dirname "$0")/.." || exit 1
rm -rf originals static
mkdir static
ln -s "$DATA/originals" originals
ln -s "$DATA/w" static/w
ln -s "$DATA/dl" static/dl
status=0
scripts/fetch.sh || status=1
DERIVE_VOLUME=1 scripts/derive.sh || status=1
echo "cluster-sync: $(ls originals | wc -l) originals, $(find static/w/ static/dl/ -type f | wc -l) files in w and dl, exit $status"
exit $status
