#!/bin/sh
# Entrypoint of the tools image. Points originals/ and static/dl at the
# mounted volume, downloads what is missing, then derives the cuts. Web
# assets (thumbnails, previews, QR codes) are skipped: they are in git
# and baked into the site image.
#
# A failed download does not stop the derive step: every painting whose
# original is present gets its cuts, and the Job still exits non-zero so
# the missing one is visible in the Kustomization status.
set -u
DATA=${DATA_DIR:-/data}
mkdir -p "$DATA/originals" "$DATA/dl"
cd "$(dirname "$0")/.." || exit 1
rm -rf originals static/dl
mkdir -p static data
ln -s "$DATA/originals" originals
ln -s "$DATA/dl" static/dl
status=0
scripts/fetch.sh || status=1
DERIVE_CUTS_ONLY=1 scripts/derive.sh || status=1
echo "cluster-sync: $(ls originals | wc -l) originals, $(find static/dl/ -type f | wc -l) files in dl, exit $status"
exit $status
