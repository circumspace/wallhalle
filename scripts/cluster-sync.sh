#!/bin/sh
# Entrypoint of the tools image. Points originals/ and static/dl at the
# mounted volume, downloads what is missing, then derives the cuts. Web
# assets (thumbnails, previews, QR codes) are skipped: they are in git
# and baked into the site image.
set -eu
DATA=${DATA_DIR:-/data}
mkdir -p "$DATA/originals" "$DATA/dl"
cd "$(dirname "$0")/.."
rm -rf originals static/dl
mkdir -p static data
ln -s "$DATA/originals" originals
ln -s "$DATA/dl" static/dl
scripts/fetch.sh
DERIVE_CUTS_ONLY=1 scripts/derive.sh
echo "cluster-sync: $(ls originals | wc -l) originals, $(find static/dl -type f | wc -l) files in dl"
